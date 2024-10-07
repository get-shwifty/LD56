extends CharacterBody2D
class_name Player

### Running
@export var RUN_SPEED := 240.0  # px/s
@export_range(0, 100, 1) var RUN_ACCELERATION := 50.0
@export_range(0, 100, 1) var RUN_DECELERATION := 50.0
# 0->49 add more force to change direction
# 50->100 = instantly change direction (from 50 with velocity 0 to 100 with same velocity)
@export_range(0, 100, 1) var RUN_TURN_SPEED := 50.0
const RUN_MAX_ACC := 10000.0

### Fall
@export var FALL_MAX_SPEED := 600.0  # px/s
@export_range(0, 100, 1) var FALL_GRAVITY := 50.0  # 0 = same gravity, 100 = double gravity

### Jumping
@export var JUMP_HEIGHT := 70.0  # px
@export var JUMP_TIME := 0.300  # s
@export_range(0, 100, 1) var JUMP_CUTOFF := 0.0  # 0 = keep jumping, 100 = abort jumping
@export var REBOUND_COEFF := 1.2  #

### Assists
@export var JUMP_BUFFER := 0.100  # time during which you can press the jump button before actually touching a floor
@export var COYOTE_TIME := 0.100  # time during which you can jump after leaving a floor

### Camera
@export_range(0, 100, 1) var CAM_LOOKAHEAD := 0.0

@onready var NOTE = preload("res://src/player/note_particle.tscn")
@onready var PARTICLE = preload("res://src/player/walk_particle.tscn")

### Teleport
@export var teleport_time = 1.0
var is_teleport = false

var counter_frame = 0

var last_fallspeed_in_air := 0.0
var coyote_time := 0.0
var jump_buffer := 0.0

enum {IDLE, RUN, JUMP}
var state = IDLE

func _ready():
	Global.player = self

func set_state(new_state):
	if state == new_state:
		return

	state = new_state
	match state:
		IDLE: on_idle()
		RUN: on_run()
		JUMP: on_jump()

func lerp_value(base100, min_value, max_value, power = 2, inverted = false) -> float:
	var value = (base100 / 100.0)
	if inverted:
		value = 1.0 - value
	return lerp(min_value, max_value, pow(value, power))

func _physics_process(delta: float) -> void:
	if is_teleport:
		velocity = Vector2.ZERO
		return
	
	var GRAVITY = 2.0 * JUMP_HEIGHT / (JUMP_TIME * JUMP_TIME)
	var can_input = not Input.is_action_pressed("sing") and %Player.get_collision_mask_value(1)

	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y *= lerp_value(FALL_GRAVITY, 1.0, 2.0, 3)
		velocity.y += GRAVITY * delta
		if velocity.y > FALL_MAX_SPEED:
			velocity.y = FALL_MAX_SPEED
		last_fallspeed_in_air = velocity.y
	else:
		if state == JUMP:
			set_state(IDLE)

		if last_fallspeed_in_air > 0:
			on_land(last_fallspeed_in_air)
			last_fallspeed_in_air = 0

	# Handle jump

	if is_on_floor():
		coyote_time = COYOTE_TIME
	else:
		coyote_time -= delta

	if can_input and Input.is_action_just_pressed("up"):
		jump_buffer = JUMP_BUFFER
	else:
		jump_buffer -= delta

	# rebound

	if state != JUMP:
		var rebound_vector = null
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			var collider = collision.get_collider()
			if collider is StaticBody2D:
				if collider.get_collision_layer_value(4):
					rebound_vector = collision.get_normal()
					collider.get_parent().play_boing()
					break

		if rebound_vector:
			jump_buffer = 0
			velocity = rebound_vector * 2.0 * JUMP_HEIGHT / JUMP_TIME * REBOUND_COEFF
			set_state(JUMP)
		else:
			if jump_buffer > 0 and coyote_time > 0:
				jump_buffer = 0
				velocity.y = -2.0 * JUMP_HEIGHT / JUMP_TIME
				set_state(JUMP)
			elif can_input and Input.is_action_just_released("up") and velocity.y < 0:
				velocity.y *= lerp_value(JUMP_CUTOFF, 0.0, 1.0, 1, true)
			elif can_input and is_on_floor() and Input.is_action_pressed("down"):
				position.y += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right") if can_input else 0.0
	if direction:
		%AnimatedSprite2D.scale.x = sign(direction)
		%PlayerMask.scale.x = sign(direction)

		var acceleration_factor = lerp_value(RUN_ACCELERATION, 0.0, RUN_MAX_ACC)

		if sign(direction) != sign(velocity.x):
			# turn so apply turn speed
			if RUN_TURN_SPEED > 49.9999:
				velocity.x *= - (RUN_TURN_SPEED -50.0) / 50.0 * 2
			else:
				acceleration_factor *= lerp_value(RUN_TURN_SPEED * 2, 1.0, 2.0)

		velocity.x += direction * acceleration_factor * delta
		if abs(velocity.x) > RUN_SPEED:
			velocity.x = RUN_SPEED * sign(velocity.x)

		if state == IDLE:
			set_state(RUN)
	else:
		velocity.x = move_toward(velocity.x, 0, lerp_value(RUN_DECELERATION, 0.0, RUN_MAX_ACC) * delta)
		if state == RUN:
			set_state(IDLE)
			
	var last_scale = %AnimatedSprite2D.scale.x
	var new_scale = sign(velocity.x)
	if new_scale == 0:
		new_scale = last_scale
	%AnimatedSprite2D.scale.x = new_scale
	%PlayerMask.scale.x = new_scale


	if is_on_ladder():
		var vertical_direction := Input.get_axis("up", "down") if can_input else 0.0
		if vertical_direction < 0:
			vertical_direction *= 0.6
		elif vertical_direction > 0:
			vertical_direction *= 1.2
		velocity.y = RUN_SPEED * vertical_direction
		on_ladder()
		# TODO lerp
	
	if velocity.x != 0:
		counter_frame += 1
		if counter_frame %  randi_range(10, 20) == 0 and is_on_floor():
			var particle = PARTICLE.instantiate()
			particle.global_position = global_position - Vector2(0, 25)
			Global.projectile_container.add_child(particle)
	
	move_and_slide()
	$Camera2D.position.x = lerp_value(CAM_LOOKAHEAD, 0.0, velocity.x)


func on_ladder():
	if is_on_floor():
		return
	if velocity.y == 0:
		%AnimatedSprite2D.play("climb")
		%AnimatedSprite2D2.play("climb")
		%AnimatedSprite2D.stop()
		%AnimatedSprite2D2.stop()
	else:
		%AnimatedSprite2D.play("climb")
		%AnimatedSprite2D2.play("climb")

func on_land(fallspeed):
	%AnimatedSprite2D.play("idle")
	%AnimatedSprite2D2.play("idle")
	$AnimationPlayer.play("RESET")
	#$AudioLand.play()

	var factor = clamp(fallspeed / FALL_MAX_SPEED, 0.0, 1.0)
	factor = pow(factor, 1.8)

	#if fallspeed < FALL_MAX_SPEED:
		#$AudioLand.play()
	#else:
		#$AudioLandHigh.play()
	$AudioLand.play()
	var tween = get_tree().create_tween()
	tween.tween_property($Visual, "scale", Vector2(1.0, 1.0) + Vector2(0.4, -0.4) * factor, 0.050)
	tween.tween_property($Visual, "scale", Vector2(1.0, 1.0), 0.200)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Visual, "position", Vector2(0.0, 6.0) * factor, 0.050)
	tween2.tween_property($Visual, "position", Vector2(0.0, 0.0), 0.200)

func on_jump():
	%AnimatedSprite2D.play("jump")
	%AnimatedSprite2D2.play("jump")
	$AnimationPlayer.play("RESET")
	$AudioJump.play()
	$AudioRun.stop()

func on_idle():
	%AnimatedSprite2D.play("idle")
	%AnimatedSprite2D2.play("idle")
	$AnimationPlayer.play("RESET")
	$Visual.skew = 0
	$AudioRun.stop()

func on_run():
	%AnimatedSprite2D.play("run")
	%AnimatedSprite2D2.play("run")
	$AnimationPlayer.play("run")
	$Visual.skew = -velocity.x / RUN_SPEED * deg_to_rad(1)
	if not $AudioRun.playing:
		$AudioRun.play()
	#print(int(global_position.x))
		
		

func teleport(position: Vector2):
	global_position = position
	state = IDLE
	velocity = Vector2.ZERO
	is_teleport = true
	#Global.play_teleport()
	hide()
	await get_tree().create_timer(teleport_time).timeout
	show()
	is_teleport = false

func is_on_ladder():
	var areas = $LadderDetection.get_overlapping_areas()
	if len(areas):
		return true
	return false

func play_note(note: String):
	var res = NOTE.instantiate()
	res.note = note
	res.global_position = %NoteSpawner.global_position
	Global.projectile_container.add_child(res)
