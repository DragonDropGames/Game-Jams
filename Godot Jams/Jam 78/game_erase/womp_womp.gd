extends Control

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")


func _on_button_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
