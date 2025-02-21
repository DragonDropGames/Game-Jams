extends CharacterBody2D
class_name Wagon

enum WAGON_TYPE { MAIN, SWORD, BOW, RESOURCE }
const BASE_LIGHT_DEPLITION_RATE: int = 0.1

# All Wagon Properties
var speed = 20
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
var menu = preload("res://UI/wagon_menu.tscn")
var menuInstance
var mouseEntered = false

# Wagon Customization Properties
@onready var bowWagonImage = get_node("WagonCollision/BowWagon")
@onready var mainWagonImage = get_node("WagonCollision/MainWagon")
@onready var resourceWagonImage = get_node("WagonCollision/ResourceWagon")
@onready var swordWagonImage = get_node("WagonCollision/SwordWagon")
@onready var lightArea = get_node("LightArea/CollisionShape2D")
@onready var point_light = $PointLight



@export var wagon: WAGON_TYPE
var lightScale: float = 10
var light_depletion_rate: int = 1

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
	match wagon:
		Enums.WAGON_TYPE.MAIN:
			speed = 15
			mainWagonImage.visible = true
			lightScale = 30
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE
			add_to_group("MainWagon", true)
		Enums.WAGON_TYPE.SWORD:
			speed = 20
			swordWagonImage.visible = true
			lightScale = 15
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE + 0.1
			add_to_group("SwordWagon", true)
		Enums.WAGON_TYPE.BOW:
			speed = 20
			bowWagonImage.visible = true
			lightScale = 15
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE +  0.2
			add_to_group("BowWagon", true)
		Enums.WAGON_TYPE.RESOURCE:
			speed = 15
			resourceWagonImage.visible = true
			lightScale = 15
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE +  0.3
			add_to_group("ResourceWagon", true)
	
	
	point_light.energy = 1
	scale_lights()

func _on_light_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.isInLight = true

func _on_light_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.isInLight = false

func _on_timer() -> void:
	if lightScale < 5:
		extinguish()
	else:
		lightScale -= light_depletion_rate
		scale_lights()

func extinguish() -> void:
	if lightScale <= 0:
		return
	
	lightScale = 0
	
	scale_lights()
	
func scale_lights() -> void:
	lightArea.scale = Vector2(lightScale, lightScale)
	point_light.scale = Vector2(lightScale, lightScale) / 25

func _on_interaction_panel_mouse_entered() -> void:
	print("here")
	mouseEntered = true

func _on_interaction_panel_mouse_exited() -> void:
	mouseEntered = false

func _on_interaction_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			print(menuInstance)
			if menuInstance == null:
				setSelected(true)
				menuInstance = menu.instantiate()
				menuInstance.showMenu(wagon, 10, position)
				add_child(menuInstance)
			else:
				setSelected(false)
				menuInstance.queue_free()
