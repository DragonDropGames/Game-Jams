extends CharacterBody2D

# ALL UNIT PROPERTIES
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
@onready var label = get_node("Label")
@export var isInLight = false


# UNIT CONFIG
var speed = 10
var health = 100
var ARMOR_SCALER = .5
@onready var resourceImage = get_node("Collision/ResourceUnit")

func _ready():
	add_to_group("Units")

func _process(delta: float) -> void:
	if !isInLight:
		label.visible = false
		health -= 10 * ARMOR_SCALER
	else:
		label.visible = true
	
func _input(event):
	if event.is_action_pressed("RightClick"):
		followCursor = true
	elif event.is_action_released("RightClick"):
		followCursor = false

func _physics_process(delta: float) -> void:
	if followCursor && isSelected:
		target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 10:
		move_and_slide()

func setSelected(value):
	isSelected = value
	selectedPanel.visible = value
	
