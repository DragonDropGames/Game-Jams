extends ControlableUnit

enum WAGON_TYPE { MAIN, SWORD, BOW, RESOURCE }
const BASE_LIGHT_DEPLITION_RATE: int = 0.1

var menu = preload("res://UI/wagon_menu.tscn")
var menuInstance
var mouseEntered = false

# Wagon Customization Properties
@onready var bowWagonImage = get_node("WagonCollision/BowWagon")
@onready var mainWagonImage = get_node("WagonCollision/MainWagon")
@onready var resourceWagonImage = get_node("WagonCollision/ResourceWagon")
@onready var swordWagonImage = get_node("WagonCollision/SwordWagon")

@export var wagon: WAGON_TYPE

func _ready():
	match wagon:
		Enums.WAGON_TYPE.MAIN:
			speed = 15
			light_scale = 30
			light_depletion_rate = 0.1
			mainWagonImage.visible = true
			
		Enums.WAGON_TYPE.SWORD:
			speed = 20
			light_scale = 15
			light_depletion_rate = 0.2
			swordWagonImage.visible = true
			
		Enums.WAGON_TYPE.BOW:
			speed = 20
			light_scale = 15
			light_depletion_rate = 0.3
			bowWagonImage.visible = true
			
		Enums.WAGON_TYPE.RESOURCE:
			speed = 15
			light_scale = 15
			light_depletion_rate = 0.4
			resourceWagonImage.visible = true
	
	ready_complete()


func _on_light_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.isInLight = true

func _on_light_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.isInLight = false

func _on_interaction_panel_mouse_entered() -> void:
	mouseEntered = true

func _on_interaction_panel_mouse_exited() -> void:
	mouseEntered = false

func _on_interaction_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if mouseEntered:
			if menuInstance == null:
				set_selected(true)
				menuInstance = menu.instantiate()
				menuInstance.showMenu(wagon, 10, position)
				add_child(menuInstance)
			else:
				set_selected(false)
				menuInstance.queue_free()
