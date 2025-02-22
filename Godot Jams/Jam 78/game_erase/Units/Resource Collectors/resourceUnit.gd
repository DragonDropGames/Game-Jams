extends CharacterBody2D

# ALL UNIT PROPERTIES
var followCursor = false
var alive = true
var gatheringResources = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
@onready var label = get_node("Label")
@export var isInLight = false
@onready var healthBar = $BasicHealthBar
@onready var workerSprite = $Collision/ResourceUnit
@onready var range = $GatherRange

# UNIT CONFIG
var speed = 10
var health = 100
var ARMOR_SCALER = .5
@onready var resourceImage = get_node("Collision/ResourceUnit")

func _ready():
	add_to_group("Units")
	add_to_group("Villagers")

func _process(delta: float) -> void:
	if !isInLight:
		label.visible = false
		health -= 10 * ARMOR_SCALER
	else:
		label.visible = true
		
	if healthBar.value != healthBar.max_value:
		healthBar.visible = true
	else:
		healthBar.visible = false
		
	if healthBar.value <= 0:
		alive = false

func _input(event):
		if event.is_action_pressed("RightClick"):
			followCursor = true
		elif event.is_action_released("RightClick"):
			followCursor = false
			

func _physics_process(delta: float) -> void:
	if alive:
		if followCursor && isSelected:
			target = get_global_mouse_position()
		
		velocity = position.direction_to(target) * speed
		
		if position.distance_to(target) > 10:
			workerSprite.play("run")
			move_and_slide()
		else:
			if gatheringResources:
				workerSprite.play('collect')
			else:
				workerSprite.play("idle")

func set_selected(value: bool):
	isSelected = value
	selectedPanel.visible = value

func _on_gather_range_body_entered(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gatheringResources = true
	pass # Replace with function body.


func _on_gather_range_body_exited(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gatheringResources = false
	pass # Replace with function body.
