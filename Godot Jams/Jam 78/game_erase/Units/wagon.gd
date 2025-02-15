extends CharacterBody2D

# All Wagon Properties
var speed = 10
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")

# Wagon Customization Properties
@onready var bowWagonImage = get_node("CollisionShape2D/BowWagon")
@onready var mainWagonImage = get_node("CollisionShape2D/MainWagon")
@onready var resourceWagonImage = get_node("CollisionShape2D/ResourceWagon")
@onready var swordWagonImage = get_node("CollisionShape2D/SwordWagon")
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
	elif event.is_action_pressed("RightClick"):
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
		speed = 5
		mainWagonImage.visible = true
		lightRadius = 30
	elif isSwordWagon:
		speed = 10
		swordWagonImage.visible = true
		lightRadius = 15
	elif isBowWagon:
		speed = 10
		bowWagonImage.visible = true
		lightRadius = 15
	elif isResourceWagon:
		speed = 15
		resourceWagonImage.visible = true
		lightRadius = 20
