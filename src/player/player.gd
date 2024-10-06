extends CharacterBody2D
class_name Player

### Running
@export var RUN_SPEED := 260.0 # px/s
@export_range(0, 100, 1) var RUN_ACCELERATION := 50.0
@export_range(0, 100, 1) var RUN_DECELERATION := 50.0
# 0->49 add more force to change direction
# 50->100 = instantly change direction (from 50 with velocity 0 to 100 with same velocity)
@export_range(0, 100, 1) var RUN_TURN_SPEED := 50.0
const RUN_MAX_ACC := 10000.0

### Fall
@export var FALL_MAX_SPEED := 1000.0 # px/s
@export_range(0, 100, 1) var FALL_GRAVITY := 50.0 # 0 = same gravity, 100 = double gravity

### Jumping
@export var JUMP_HEIGHT := 100.0 # px
@export var JUMP_TIME := 0.300 # s
@export_range(0, 100, 1) var JUMP_CUTOFF := 0.0 # 0 = keep jumping, 100 = abort jumping

### Assists
@export var JUMP_BUFFER := 0.100 # time during which you can press the jump button before actually touching a floor
@export var COYOTE_TIME := 0.100 # time during which you can jump after leaving a floor

### Camera
@export_range(0, 100, 1) var CAM_LOOKAHEAD := 0.0

var was_on_floor := false
var last_fallspeed_in_air := 0.0
var coyote_time := 0.0
var jump_buffer := 0.0

enum { IDLE, RUN, JUMP }
var state = IDLE

func _ready():
	Global.player = self

func set_state(new_state):
	if state == new_state:
		return

	if state == JUMP and new_state == IDLE:
		on_land()

	state = new_state
	match state:
		IDLE: on_idle()
		RUN: on_run()
		JUMP: on_jump()

func lerp_value(base100, min_value, max_value, power=2, inverted=false) -> float:
	var value = (base100 / 100.0)
	if inverted:
		value = 1.0 - value
	return lerp(min_value, max_value, pow(value, power))

func _physics_process(delta: float) -> void:
	var GRAVITY = 2.0 * JUMP_HEIGHT / (JUMP_TIME * JUMP_TIME)

	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity.y *= lerp_value(FALL_GRAVITY, 1.0, 2.0, 3)
		velocity.y += GRAVITY * delta
		if velocity.y > FALL_MAX_SPEED:
			velocity.y = FALL_MAX_SPEED
		last_fallspeed_in_air = velocity.y

	if state == JUMP and is_on_floor():
		set_state(IDLE)
	was_on_floor = is_on_floor()

	# Handle jump

	if is_on_floor():
		coyote_time = COYOTE_TIME
	else:
		coyote_time -= delta
	
	if Input.is_action_just_pressed("up"):
		jump_buffer = JUMP_BUFFER
	else:
		jump_buffer -= delta

	if jump_buffer > 0 and coyote_time > 0:
		jump_buffer = 0
		velocity.y = -2.0 * JUMP_HEIGHT / JUMP_TIME
		set_state(JUMP)
	elif Input.is_action_just_released("up") and velocity.y < 0:
		velocity.y *= lerp_value(JUMP_CUTOFF, 0.0, 1.0, 1, true)
	elif is_on_floor() and Input.is_action_pressed("down"):
		position.y += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		var acceleration_factor = lerp_value(RUN_ACCELERATION, 0.0, RUN_MAX_ACC)
		
		if sign(direction) != sign(velocity.x):
			# turn so apply turn speed
			if RUN_TURN_SPEED > 49.9999:
				velocity.x *= - (RUN_TURN_SPEED-50.0)/50.0 * 2
			else:
				acceleration_factor *= lerp_value(RUN_TURN_SPEED*2, 1.0, 2.0)

		velocity.x += direction * acceleration_factor * delta
		if abs(velocity.x) > RUN_SPEED:
			velocity.x = RUN_SPEED * sign(velocity.x)
		
		if state == IDLE:
			set_state(RUN)
	else:
		velocity.x = move_toward(velocity.x, 0, lerp_value(RUN_DECELERATION, 0.0, RUN_MAX_ACC) * delta)
		if state == RUN:
			set_state(IDLE)
		
	
	if is_on_ladder() and Input.is_action_pressed("up"):
		velocity.y = -RUN_SPEED
	elif is_on_ladder() and Input.is_action_pressed("down"):
		velocity.y = RUN_SPEED
	elif is_on_ladder():
		velocity.y = 0
	move_and_slide()
	$Camera2D.position.x = lerp_value(CAM_LOOKAHEAD, 0.0, velocity.x)

func on_land():
	%AnimatedSprite2D.play("idle")
	%AnimatedSprite2D2.play("idle")
	$AnimationPlayer.play("RESET")
	
	var factor = clamp(last_fallspeed_in_air / FALL_MAX_SPEED, 0.0, 1.0)
	factor = pow(factor, 1.8)
	
	var tween = get_tree().create_tween()
	tween.tween_property($Visual, "scale", Vector2(1.0, 1.0) + Vector2(0.4, -0.4)*factor, 0.050)
	tween.tween_property($Visual, "scale", Vector2(1.0, 1.0), 0.200)
	var tween2 = get_tree().create_tween()
	tween2.tween_property($Visual, "position", Vector2(0.0, 6.0)*factor, 0.050)
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
	%AnimatedSprite2D.scale.x = sign(velocity.x)
	%AnimatedSprite2D2.play("run")
	%AnimatedSprite2D2.scale.x = sign(velocity.x)
	$AnimationPlayer.play("run")
	$Visual.skew = -velocity.x / RUN_SPEED * deg_to_rad(1)
	if not $AudioRun.playing:
		$AudioRun.play()
	
func teleport(position: Vector2):
	global_position = position
	was_on_floor = true
	velocity = Vector2.ZERO

func is_on_ladder():
	var areas = $LadderDetection.get_overlapping_areas()
	if len(areas):
		return true
	return false
	
func play_note(note: String):
	pass
