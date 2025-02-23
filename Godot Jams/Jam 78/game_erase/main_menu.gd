extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_button_2_pressed() -> void:
	get_tree().quit()
