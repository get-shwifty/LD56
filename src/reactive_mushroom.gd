extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reactive_component_on_reaction() -> void:
	$Timer.start()
	# TODO animate blend
	$Activated.show()
	$Disabled.hide()


func _on_timer_timeout() -> void:
	$Activated.hide()
	$Disabled.show()
