extends Control

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://World/world.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_controls_pressed() -> void:
	$RichTextLabel3.visible = !$RichTextLabel3.visible
	pass # Replace with function body.


func _on_goal_pressed() -> void:
	$RichTextLabel.visible = !$RichTextLabel.visible
	pass # Replace with function body.
