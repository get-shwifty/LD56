extends Node2D

@export var action = "home"

@onready var runes_sprites = $runes.get_children()
@onready var song_activation = Settings.songs[action]

var ignore = true

func _ready():
	Global.tp_steles.append(self)
	$AnimatedSprite2D.hide()
	$InRange.emitting = false

func on_song(song: String):
	if ignore:
		return
	var max_i = len(song_activation)
	var index = max_i
	while index > 0:
		if song.ends_with(song_activation.substr(0, index)):
			break
		index -= 1
	for i in range(index):
		runes_sprites[i].on()
	for i in range(index, max_i):
		runes_sprites[i].off()
		
func on_song_finished(name: String):
	if ignore: return
	if name == action:
		var player = Global.player
		player.teleport(global_position)
		$AudioStreamPlayer.play()
		$AnimatedSprite2D.play("tp")
		$AnimatedSprite2D.show()
		await $AnimatedSprite2D.animation_finished
		$AnimatedSprite2D.hide()
		


func _on_reactive_component_activate():
	print('heeleloo')
	ignore = false
	$InRange.emitting = true


func _on_reactive_component_deactivate():
	ignore = true
	$InRange.emitting = false
