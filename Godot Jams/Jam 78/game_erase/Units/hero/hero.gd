extends CharacterBody2D

var speed = 60
var maxHealth = 1200
var health = maxHealth
var alive = true
var followCursor = false

@onready var heroSprite = $CollisionShape2D/Hero
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
@onready var healthBar = get_node("BasicHealthBar")
@onready var hplabel = $Label
@onready var point_light: PointLight2D = $PointLight
@onready var light_collision: Area2D = $LightArea

var lightScale: float = 10
var light_depletion_rate: int = 0

func _ready():
	add_to_group("Wagons", true)
	healthBar.max_value = maxHealth
	healthBar.value = maxHealth
	hplabel.text= str(healthBar.max_value)
	
func _process(delta: float) -> void:
	if alive &&  healthBar.value != healthBar.max_value:
		healthBar.visible = true
		if healthBar.value <= 0:
			alive = false
			heroSprite.play("die")
	else:
		healthBar.visible = false
		
	
	
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
		heroSprite.play('run')
		move_and_slide()
	else:
		heroSprite.play('idle')
func setSelected(value):
	isSelected = value
	selectedPanel.visible = value
