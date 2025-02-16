extends CharacterBody2D

# All Wagon Properties
var speed = 20
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")

# Wagon Customization Properties
@onready var bowWagonImage = get_node("BowWagon")
@onready var mainWagonImage = get_node("MainWagon")
@onready var resourceWagonImage = get_node("ResourceWagon")
@onready var swordWagonImage = get_node("SwordWagon")
@export var isMainWagon = false
@export var isSwordWagon = false
@export var isBowWagon = false
@export var isResourceWagon = false
var lightRadius = 0

func _ready():
	add_to_group("Wagons", true)
	setProperties()

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
	
func setProperties():
	if isMainWagon:
		speed = 15
		mainWagonImage.visible = true
		lightRadius = 30
		add_to_group("MainWagon", true)
	elif isSwordWagon:
		speed = 20
		swordWagonImage.visible = true
		lightRadius = 15
		add_to_group("SwordWagon", true)
	elif isBowWagon:
		speed = 20
		bowWagonImage.visible = true
		lightRadius = 15
		add_to_group("BowWagon", true)
	elif isResourceWagon:
		speed = 15
		resourceWagonImage.visible = true
		lightRadius = 20
		add_to_group("ResourceWagon", true)
