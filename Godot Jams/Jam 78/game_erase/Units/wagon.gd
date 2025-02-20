extends CharacterBody2D

enum WAGON_TYPE { MAIN, SWORD, BOW, RESOURCE }
const BASE_LIGHT_DEPLITION_RATE: int = 0.1

# All Wagon Properties
var speed = 20
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")

# Wagon Customization Properties
@onready var bowWagonImage = get_node("WagonCollision/BowWagon")
@onready var mainWagonImage = get_node("WagonCollision/MainWagon")
@onready var resourceWagonImage = get_node("WagonCollision/ResourceWagon")
@onready var swordWagonImage = get_node("WagonCollision/SwordWagon")
@onready var lightArea = get_node("LightArea/CollisionShape2D")
@onready var point_light = $PointLight


@export var wagon: WAGON_TYPE
var lightScale: Vector2 = Vector2(10, 10)
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
		WAGON_TYPE.MAIN:
			speed = 15
			mainWagonImage.visible = true
			lightScale = Vector2(30, 30)
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE
			add_to_group("MainWagon", true)
		WAGON_TYPE.SWORD:
			speed = 20
			swordWagonImage.visible = true
			lightScale = Vector2(15, 15)
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE + 0.1
			add_to_group("SwordWagon", true)
		WAGON_TYPE.BOW:
			speed = 20
			bowWagonImage.visible = true
			lightScale = Vector2(15, 15)
			light_depletion_rate = BASE_LIGHT_DEPLITION_RATE +  0.2
			add_to_group("BowWagon", true)
		WAGON_TYPE.RESOURCE:
			speed = 15
			resourceWagonImage.visible = true
			lightScale = Vector2(15, 15)
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
	if lightScale < Vector2(5, 5):
		extinguish()
	else:
		lightScale -= Vector2(light_depletion_rate, light_depletion_rate)
		scale_lights()

func extinguish() -> void:
	if lightScale <= Vector2.ZERO:
		return
	
	lightScale = Vector2.ZERO
	
	scale_lights()
	
func scale_lights() -> void:
	lightArea.scale = lightScale
	point_light.scale = lightScale / 25
