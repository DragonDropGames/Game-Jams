extends CharacterBody2D


@export var selected = false
@onready var box = get_node("Box")

@onready var target = position
var follow_cursor = false
var Speed = 50

func _ready():
	set_selected(selected)
	
func set_selected(value):
	selected = value
	box.visible = value

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("Right Click"):
		follow_cursor = true
	
	if event.is_action_released("Right Click"):
		follow_cursor = false

func _physics_process(delta: float) -> void:
	if follow_cursor:
		if selected:
			target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * Speed
	if position.distance_to(target) > 10:
		move_and_slide()
	else:
		pass
