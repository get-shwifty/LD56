extends Node2D

const PLAYER_FALL_Y := 50.0
const ATTACK_LEFT_FOLLOW := 5.0
const POING_SPEEDX := 50.0
const POING_SPEEDY := 5.0
const POING_SPEEDY_ATT := 1500.0
const POING_X1 := -300.0
const POING_H0 := -300.0
const POING_H1 := -300.0
const POING_H2 := -400.0
const POING_H3 := -65.0 - PLAYER_FALL_Y
const POINGL_MIN_X := -200.0
const POINGL_MAX_X := -100.0

const BIRDS_SPEED := 500.0

const EASY_MODE := 0.8

var current_phase = 1

enum { FOLLOWING, PREPARING, ATTACKING }

var left_time := -8.0 * EASY_MODE
var left_target_y := POING_H1
var left_state := FOLLOWING

var right_time := -8.0 * EASY_MODE
var right_target_y := POING_H1
var right_state := FOLLOWING

func _ready():
	$Boss/Left.modulate = Color(1.0, 1.0, 1.0, 0.0)
	$Boss/Right.modulate = Color(1.0, 1.0, 1.0, 0.0)
	Global.map = self
	Global.projectile_container = $Projectiles
	
	var tween = get_tree().create_tween()
	Engine.time_scale = 0.3
	tween.tween_property(Engine, "time_scale", 0.3, 0.5)
	tween.tween_property(Engine, "time_scale", 1.0, 0.2)
	put_player_down()


func _physics_process(delta: float):
	%Birds.progress += BIRDS_SPEED * delta
	
	if left_time < 0 and left_time + delta * EASY_MODE >= 0:
		var tween = get_tree().create_tween()
		tween.tween_property($Boss/Left, "modulate", Color.WHITE, 0.300)
		var tween2 = get_tree().create_tween()
		tween2.tween_property($Boss/Right, "modulate", Color.WHITE, 0.300)

	left_time += delta * EASY_MODE
	right_time += delta * EASY_MODE
	
	var player_position = %Player.position
	if player_position.y > 50.0:
		%Player.set_collision_mask_value(1, true)
	
	if left_time < 0:
		return
	
	# LEFT
	
	match left_state:
		FOLLOWING:
			if left_time > 3.0:
				left_state = PREPARING
		PREPARING:
			if left_time > 5.0:
				left_state = ATTACKING
				$Boss/Left/Overlaypoing.show()
				$Boss/Left/Kill.set_collision_mask_value(8, true)
		ATTACKING:
			if left_time > 5.5:
				left_state = FOLLOWING
				left_time = 0.0
				$Boss/Left/Overlaypoing.hide()
				$Boss/Left/Kill.set_collision_mask_value(8, false)
	
	var left_target_follow = left_state != ATTACKING
	
	if left_target_follow:
		var target_x = clamp(player_position.x, POINGL_MIN_X, POINGL_MAX_X)
		var diff_x = target_x - $Boss/Left.position.x
		$Boss/Left.position.x += clamp(diff_x, -POING_SPEEDX*delta, +POING_SPEEDX*delta)
	
	var cur_ltarget_y = 0.0
	match left_state:
		FOLLOWING:
			cur_ltarget_y = POING_H1
		PREPARING:
			cur_ltarget_y = POING_H2
		ATTACKING:
			cur_ltarget_y = POING_H3

	if left_target_follow:
		cur_ltarget_y += player_position.y
	
	if left_state == ATTACKING:
		$Boss/Left.position.y += POING_SPEEDY_ATT * delta
		if $Boss/Left.position.y > cur_ltarget_y:
			$Boss/Left.position.y = cur_ltarget_y
			$Boss/Left/Kill.set_collision_mask_value(8, false)
	else:
		$Boss/Left.position.y = lerp($Boss/Left.position.y, cur_ltarget_y, POING_SPEEDY*delta)
	
	shake($Boss/Left, left_time / EASY_MODE, left_state == PREPARING)
	front($Boss/Left, left_state == PREPARING or left_state == ATTACKING)

	# RIGHT
	
	match right_state:
		FOLLOWING:
			if right_time > 5.75:
				right_state = PREPARING
		PREPARING:
			if right_time > 7.75:
				right_state = ATTACKING
				$Boss/Right/Overlaypoing.show()
				$Boss/Right/Kill.set_collision_mask_value(8, true)
		ATTACKING:
			if right_time > 8.25:
				right_state = FOLLOWING
				right_time = 0.0
				$Boss/Right/Overlaypoing.hide()
				$Boss/Right/Kill.set_collision_mask_value(8, false)
	
	var right_target_follow = right_state != ATTACKING
	
	#if right_target_follow:
		#var target_x = clamp(player_position.x, POINGL_MIN_X, POINGL_MAX_X)
		#var diff_x = target_x - $Boss/Left.position.x
		#$Boss/Left.position.x += clamp(diff_x, -POING_SPEEDX*delta, +POING_SPEEDX*delta)
	
	var cur_rtarget_y = 0.0
	match right_state:
		FOLLOWING:
			cur_rtarget_y = POING_H1
		PREPARING:
			cur_rtarget_y = POING_H2
		ATTACKING:
			cur_rtarget_y = POING_H3

	if right_target_follow:
		cur_rtarget_y += player_position.y
	
	if right_state == ATTACKING:
		$Boss/Right.position.y += POING_SPEEDY_ATT * delta
		if $Boss/Right.position.y > cur_rtarget_y:
			$Boss/Right.position.y = cur_rtarget_y
			$Boss/Right/Kill.set_collision_mask_value(8, false)
	else:
		$Boss/Right.position.y = lerp($Boss/Right.position.y, cur_rtarget_y, POING_SPEEDY*delta)
	
	shake($Boss/Right, right_time / EASY_MODE, right_state == PREPARING)
	front($Boss/Right, right_state == PREPARING or right_state == ATTACKING)

func shake(node: Node2D, time, do_shake):
	node.rotation = sin(time*20.0) * 0.05 if do_shake else 0.0

func front(node: Node2D, do_front):
	node.z_index = 10 if do_front else 0


func _on_left_kill_body_entered(body: Node2D) -> void:
	put_player_down()
	left_time = 100.0
	right_time = 100.0
	$Player/Camera2D.shake_on_hit()

func _on_right_kill_body_entered(body: Node2D) -> void:
	put_player_down()
	left_time = 100.0
	right_time = 100.0
	$Player/Camera2D.shake_on_hit()
	
func put_player_down():
	%Player.set_collision_mask_value(1, false)


func _on_panier_body_entered(body: Node2D) -> void:
	current_phase = 2
	left_time = 100.0
	right_time = 100.0
	$AnimationPlayer.play("fall")
	%SteleBirds.show()
	Engine.time_scale = 0.3
	var tween = get_tree().create_tween()
	tween.tween_property(Engine, "time_scale", 0.3, 0.4)
	tween.tween_property(Engine, "time_scale", 1.0, 0.2)
	put_player_down()


func _on_stele_birds_on_played() -> void:
	if %Player.position.y < -1050:
		left_time = -100.0
		right_time = -100.0
		%Player.set_collision_mask_value(1, false)
		%Player.is_teleport = true
		%Player/Visual/AnimatedSprite2D.play("climb")
		%Player/Visual/PlayerMask.hide()
		var tween = get_tree().create_tween()
		tween.tween_property(%Player, "position", Vector2(0.0, -1112.0), 3.0)
		tween.tween_property($FinalColorRect, "modulate", Color.WHITE, 5.0)
		$Boss/Left.z_index = 0
		$Boss/Right.z_index = 0
		$Memory.hide()
		await get_tree().create_timer(8.0).timeout
		get_tree().change_scene_to_file("res://src/end_scene.tscn")
	


func _on_show_shroom_body_entered(body: Node2D) -> void:
	if current_phase == 2:
		var tween = get_tree().create_tween()
		tween.tween_property($Memory/SteleBirds, "modulate", Color.WHITE, 0.500)
