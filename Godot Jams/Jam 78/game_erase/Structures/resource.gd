extends StaticBody2D

enum RESOURCE_TYPE { Iron, Wood }
@export var resourceType: RESOURCE_TYPE

var total_resources: int
var current_resources: int
var units: int = 0
var type: String;

@onready var bar = $TextureProgressBar
@onready var timer = $Timer
@onready var iron = $Iron
@onready var wood = $Wood

func _ready() -> void:
	add_to_group('Resource')
	setProperties()
	current_resources = total_resources
	bar.max_value = total_resources
	bar.value = total_resources

func _process(delta: float) -> void:
	if bar.value <= 0:
		resourceCollected()

func setProperties() -> void:
	match resourceType:
		RESOURCE_TYPE.Iron:
			total_resources = 120
			type = "iron"
			pass

func resourceCollected():
	position = Vector2(-50,-50)
	
func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Villagers"):
		units += 1
		timer.start()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Villagers"):
		units -= 1
		if units <= 0:
			timer.stop()

func _on_timer_timeout() -> void:
	var chopSpeed = 1 * units
	bar.value -= chopSpeed
	if type == "iron":
		Game.iron_label += 1 * units
		
