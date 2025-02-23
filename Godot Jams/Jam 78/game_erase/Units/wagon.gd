extends ControlableUnit

enum WAGON_TYPE { MAIN, SWORD, BOW, RESOURCE }
const BASE_LIGHT_DEPLITION_RATE: int = 0.1

var menu = preload("res://UI/wagon_menu.tscn")
var menuInstance
var mouseEntered = false

# Wagon Customization Properties
var wagon_image: AnimatedSprite2D
@export var wagon: WAGON_TYPE

func _ready():
	speed = 30
	add_to_group("Wagons")
	health = 600
	match wagon:
		Enums.WAGON_TYPE.MAIN:
			light_scale = 60
			wagon_image = $Collision/MainWagon
			
		Enums.WAGON_TYPE.SWORD:
			light_scale = 40
			wagon_image = $Collision/MainWagon
			
		Enums.WAGON_TYPE.BOW:
			light_scale = 40
			wagon_image = $Collision/MainWagon 
			
		Enums.WAGON_TYPE.RESOURCE:
			light_scale = 50
			wagon_image = $Collision/ResourceWagon
	
	wagon_image.visible = true
	ready_complete()

func _process(delta):
	
	if !alive:
		if is_selected:
			set_selected(false)
		if menuInstance != null:
			menuInstance.queue_free()

	var left = velocity.x < 0
	var top = velocity.y < 0
	var play_position: String
	
	if top and left:
		play_position = "top-left"
	elif top and not left:
		play_position = "top-right"
	elif not top and left:
		play_position = "bottom-left"
	else:
		play_position = "bottom-right"
	
	if wagon_image:
		wagon_image.play(play_position)
	
func _on_light_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("ControllableUnits"):
		body.in_light = true

func _on_light_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("ControllableUnits"):
		body.in_light = false

func _on_interaction_panel_mouse_entered() -> void:
	mouseEntered = true

func _on_interaction_panel_mouse_exited() -> void:
	mouseEntered = false

func _on_interaction_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and alive:
		if mouseEntered:
			if menuInstance == null:
				set_selected(true)
				menuInstance = menu.instantiate()
				menuInstance.showMenu(wagon, 10, position)
				add_child(menuInstance)
			else:
				set_selected(false)
				menuInstance.queue_free()
