extends StaticBody2D

var mouseEntered = false
var selected = false

@onready var select = get_node("Selected")

func _ready() -> void:
	add_to_group("Building", true)

func _process(delta: float) -> void:
	select.visible = selected

func _input(event):
	if event.is_action_pressed("Left Click"):
		if mouseEntered:
			selected = !selected
			if selected:
				Game.spawnUnit(position)

func _on_mouse_entered() -> void:
	mouseEntered = true

func _on_mouse_exited() -> void:
	mouseEntered = false
