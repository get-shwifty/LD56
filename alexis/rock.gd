extends Node2D

const ANIM_DURATION = 0.150
const ANIM_MOVE_DURATION = 0.300
const MOVE_SPEED = 100
var tween
var tween_move

@export var is_tall = false
@export var is_enabled = false
var moving_factor : float = 0.0
var vibrate = false
var t := 0.0

func _ready():
	$AuraLoop.hide()
	if is_tall:
		$MovingPart.position.y = -32.0
	if is_enabled:
		$MovingPart/VeryShort.modulate.a = 1.0
		$MovingPart/VeryShort.collision_layer = 1

func _physics_process(delta: float):
	if moving_factor < 0.0:
		if Input.is_action_pressed("a") and not $RayCast2DLeft.is_colliding() and $RayCast2DDownLeft.is_colliding():
			position.x -= MOVE_SPEED * delta
		else:
			moving_factor = 0.0
	if moving_factor > 0.0:
		if Input.is_action_pressed("c") and not $RayCast2DRight.is_colliding() and $RayCast2DDownRight.is_colliding():
			position.x += MOVE_SPEED * delta
		else:
			moving_factor = 0.0
	
	if vibrate:
		t += delta
		var offset = sin(t * 15.0) * 1.0
		$Sprite2D2.position.x = offset
		$MovingPart.position.x = offset
	else:
		t = 0.0
		$Sprite2D2.position.x = 0.0
		$MovingPart.position.x = 0.0

func on_melody(melody: String, rest: String):
	var adj = "c" if is_tall else "a"
	
	if $MovingPart/VeryShort.collision_layer != 1 and melody == "MelodyActiverPierre": # enable
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property($MovingPart/VeryShort, "modulate:a", 1.0,
			(1.0 - $MovingPart/VeryShort.modulate.a) * ANIM_DURATION)
		$MovingPart/VeryShort.collision_layer = 1
		
		return true
	
	elif $MovingPart/VeryShort.collision_layer != 0 and melody == "MelodyDesactiverPierre": # disable
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property($MovingPart/VeryShort, "modulate:a", 0.0,
			$MovingPart/VeryShort.modulate.a * ANIM_DURATION)
		$MovingPart/VeryShort.collision_layer = 0
		
		return true
	
	elif melody == "MelodyMovePierre":
		if rest != "":
			vibrate = false
			$AuraLoop.hide()

		match rest:
			"": # pending move
				vibrate = true
				$AuraLoop.show()
				return true
			"a", "d", "g": # move left
				moving_factor = -1.0
				return false
			"c", "f", "i": # move right
				moving_factor = 1.0
				return false
	else:
		vibrate = false
		$AuraLoop.hide()
