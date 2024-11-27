extends Node2D

@onready var runes = $Runes.get_children()

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

# rock = bc
# small = a
# tall = c
# activate = d
# transform = e
# move = f
# left = long a
# right = long c

func _ready():
	$AuraLoop.hide()
	if is_tall:
		$MovingPart.position.y = -32.0
		runes[0].rotation_degrees = 180.0
	if is_enabled:
		$MovingPart/VeryShort.modulate.a = 1.0
		$MovingPart/VeryShort.collision_layer = 1

func _physics_process(delta: float):
	if moving_factor < 0.0:
		if Input.is_action_pressed("a") and not $RayCast2DLeft.is_colliding() and $RayCast2DDownLeft.is_colliding():
			position.x -= MOVE_SPEED * delta
		else:
			moving_factor = 0.0
			runes[0].deactivate()
			runes[1].deactivate()
			runes[2].deactivate()
	if moving_factor > 0.0:
		if Input.is_action_pressed("c") and not $RayCast2DRight.is_colliding() and $RayCast2DDownRight.is_colliding():
			position.x += MOVE_SPEED * delta
		else:
			moving_factor = 0.0
			runes[0].deactivate()
			runes[1].deactivate()
			runes[2].deactivate()
	
	if vibrate:
		t += delta
		var offset = sin(t * 15.0) * 1.0
		$Sprite2D2.position.x = offset
		$MovingPart.position.x = offset
		$Runes.position.x = offset
	else:
		t = 0.0
		$Sprite2D2.position.x = 0.0
		$MovingPart.position.x = 0.0
		$Runes.position.x = 0.0

func on_song(song):
	var adj = "c" if is_tall else "a"
	
	# vibration
	if song == "fbc" + adj: # pending move
		vibrate = true
		$AuraLoop.show()
	else:
		vibrate = false
		$AuraLoop.hide()
	
	# runes
	
	#if song.ends_with(adj+"bc"):
		#runes[0].show()
		#runes[1].show()
		#runes[2].show()
		#runes[0].activate()
		#runes[1].activate()
		#runes[2].activate()
	#else:
		#runes[0].hide()
		#runes[1].hide()
		#runes[2].hide()
		#runes[0].deactivate()
		#runes[1].deactivate()
		#runes[2].deactivate()
	#elif song.ends_with(adj+"b"):
		#runes[0].activate()
		#runes[1].activate()
		#runes[2].deactivate()
	#elif song.ends_with(adj):
		#runes[0].activate()
		#runes[1].deactivate()
		#runes[2].deactivate()
	#else:
		#runes[0].deactivate()
		#runes[1].deactivate()
		#runes[2].deactivate()
	
	# actions
	
	if $MovingPart/VeryShort.collision_layer != 1 and song == ("dbc" + adj): # enable
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property($MovingPart/VeryShort, "modulate:a", 1.0,
			(1.0 - $MovingPart/VeryShort.modulate.a) * ANIM_DURATION)
		$MovingPart/VeryShort.collision_layer = 1
		
		return true
	
	elif $MovingPart/VeryShort.collision_layer != 0 and song == ("gbc" + adj): # disable
		if tween:
			tween.kill()
		tween = get_tree().create_tween()
		tween.tween_property($MovingPart/VeryShort, "modulate:a", 0.0,
			$MovingPart/VeryShort.modulate.a * ANIM_DURATION)
		$MovingPart/VeryShort.collision_layer = 0
		
		return true

	#elif not is_tall and song == ("ebcac"): # transform tall
		#is_tall = true
		#if tween_move:
			#tween_move.kill()
		#var t = (32.0 + $MovingPart.position.y) / 32.0
		#tween_move = get_tree().create_tween().set_parallel(true)
		#tween_move.tween_property($MovingPart, "position:y", -32.0, t * ANIM_MOVE_DURATION)
		#tween_move.tween_property(runes[0], "rotation_degrees", 180.0, t * ANIM_MOVE_DURATION)
		#
		#return true
#
	#elif is_tall and song == ("ebcca"): # transform small
		#is_tall = false
		#if tween_move:
			#tween_move.kill()
		#var t = -$MovingPart.position.y / 32.0
		#tween_move = get_tree().create_tween().set_parallel(true)
		#tween_move.tween_property($MovingPart, "position:y", 0.0, t * ANIM_MOVE_DURATION)
		#tween_move.tween_property(runes[0], "rotation_degrees", 0.0, t * ANIM_MOVE_DURATION)
		#
		#return true

	elif song == ("fbc" + adj + "a"): # move left
		moving_factor = -1.0
		
		return true

	elif song == ("fbc" + adj + "c"): # move right
		moving_factor = 1.0
		
		return true
