extends CanvasLayer

func _process(delta: float):
	if Global.speedrun_time > 0:
		update_label(Global.speedrun_time)
	elif Global.speedrun_start_time > 0:
		update_label(Time.get_ticks_msec() - Global.speedrun_start_time)
	else:
		$RichTextLabel.hide()

func update_label(time):
	$RichTextLabel.show()
	var ms = time % 1000
	time = floori(time / 1000)
	var s = time % 60
	time = floori(time / 60)
	
	$RichTextLabel.text = "[center]%02d:%02d:%03d" % [time, s, ms]
