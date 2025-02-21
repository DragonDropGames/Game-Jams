extends CharacterBody2D

var speed = 20
var maxHealth = 1200

var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
@onready var healthBar = get_node("BasicHealthBar")
@onready var hplabel = $Label
var lightScale: float = 10
var light_depletion_rate: int = 0

func _ready():
	add_to_group("Wagons", true)
	healthBar.max_value = maxHealth
	hplabel.text= str(healthBar.max_value)
	
func _process(delta: float) -> void:
	
	pass
	
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
