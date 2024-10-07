extends AudioStreamPlayer

@onready var voice1 = preload("res://sounds/Chanterelle_Voix_1.mp3")


# Called when the node enters the scene tree for the first time.
#func _ready():
	#stream = voice1
	#rand_voice()
#
#func rand_voice():
	#var time = randi_range(5, 20)
	#$Timer.wait_time = time
	#$Timer.start()
#
#
#func _on_timer_timeout():
	#if not get_parent().is_teleport:
		#play()
