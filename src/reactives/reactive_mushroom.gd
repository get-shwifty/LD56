extends Node2D

@export var song_name = "mushroom"
@export var one_jump = false
@onready var boings = [preload("res://sounds/Son-rebond-champignon-1.mp3"), preload("res://sounds/Son-rebond-champignon-2.mp3"), preload("res://sounds/Son-rebond-champignon-3.mp3")]

@onready var light: Node2D = $Light

var counter = 0
var active = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	#print(light.get_parent())
	deactivate()

func _physics_process(delta):
	light.global_position = global_position
	

func activate():
	$Champi.play("on")
	$Ground/CollisionShape2D.disabled = false
	light.on()
	active = true
	
func deactivate():
	if $Ground/CollisionShape2D.disabled:
		return
	$Champi.play("off")
	$Ground/CollisionShape2D.disabled = true
	light.off()
	active = false


func play_boing():
	$Particles.restart()
	$Particles.emitting = true
	$BoingPlayer.stream = boings[counter % 3]
	$BoingPlayer.play()
	counter += 1
	
	if one_jump:
		deactivate()


func _on_reactive_component_activate():
	activate()


func _on_reactive_component_deactivate():
	deactivate()
