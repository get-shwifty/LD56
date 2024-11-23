@tool
extends Node2D

const W = 768.0
const H = 432.0

func _draw():
	if Engine.is_editor_hint():
		for i in range(-10, 10):
			for j in range(-10, 10):
				draw_rect(Rect2(i*W + 1.0, j*H + 1.0, W - 2.0, H - 2.0), Color.DARK_RED, false, 2.0)
