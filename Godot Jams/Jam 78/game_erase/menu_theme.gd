extends AudioStreamPlayer2D

player.connect("finished", Callable(self,"_on_loop_sound").bind(player))
player.play()

func _on_loop_sound(player):
	player.stream_paused = false
