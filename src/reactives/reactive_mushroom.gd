extends Node2D

@export var song_name = "mushroom"
@export var one_jump = false
@onready var boings = [preload("res://sounds/Son-rebond-champignon-1.mp3"), preload("res://sounds/Son-rebond-champignon-2.mp3"), preload("res://sounds/Son-rebond-champignon-3.mp3")]

@onready var light: Node2D = $Light

var counter = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().physics_frame
	#print(light.get_parent())
	deactivate()

func _physics_process(delta):
	light.global_position = global_position

func on_song(song: String):
	pass
		
func on_song_finished(name: String):
	if name == song_name:
		activate()
	

func activate():
	$Champi.play("on")
	$Ground/CollisionShape2D.disabled = false
	$Timer.start()
	Global.request_music = "shroom"
	light.on()
	
func deactivate():
	if $Ground/CollisionShape2D.disabled:
		return
	$Champi.play("off")
	$Ground/CollisionShape2D.disabled = true
	light.off()


func _on_timer_timeout():
	deactivate()


func play_boing():
	$Particles.restart()
	$Particles.emitting = true
	$BoingPlayer.stream = boings[counter % 3]
	$BoingPlayer.play()
	counter += 1
	
	if one_jump:
		$Ground/CollisionShape2D.disabled = true
		light.off()
		await $Timer.timeout
		#$Ground/CollisionShape2D.disabled = false
