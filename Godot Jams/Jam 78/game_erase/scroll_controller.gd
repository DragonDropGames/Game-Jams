extends Node2D

var scroll = 0

func _process(delta: float) -> void:
	scroll -= 200 * delta
	$"..".scroll_offset.x = scroll
