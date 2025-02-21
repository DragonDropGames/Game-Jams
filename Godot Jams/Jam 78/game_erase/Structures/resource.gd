extends StaticBody2D

enum RESOURCE_TYPE { Iron, Food, Wood }
@export var resourceType: RESOURCE_TYPE

var totalTime = 5
var currTime
var units = 0
var type;

@onready var bar = $TextureProgressBar
@onready var timer = $Timer
@onready var iron = $Iron
@onready var wood = $Wood
@onready var food = $Food

func _ready() -> void:
	setProperties()
	currTime = totalTime
	bar.max_value = totalTime
	bar.value = totalTime

func _process(delta: float) -> void:
	if currTime <= 0:
		resourceCollected()

func setProperties() -> void:
	match resourceType:
		RESOURCE_TYPE.Iron:
			type = 'iron'
			totalTime = 300
			pass
		RESOURCE_TYPE.Food:
			type = 'food'
			pass
		RESOURCE_TYPE.Wood:
			totalTime = 60
			type = 'wood'
			pass	

func resourceCollected():
	queue_free()
	
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
	currTime -= chopSpeed
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", currTime, 0.5).set_trans(Tween.TRANS_QUAD)
	
	if type == 'iron':
		Game.iron_label += 2
	if type == 'wood':
		Game.wood_label += 8
	if type == 'food':
		Game.food_label += 3
