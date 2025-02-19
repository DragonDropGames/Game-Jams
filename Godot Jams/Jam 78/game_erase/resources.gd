extends Node

class_name Global_Resources

static var iron_label: int;
static var wood_label: int;
static var food_label: int;

enum type {Iron,Wood,Food}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func updateResource(type,value):
	match type:
		type.Iron:
			iron_label += value
			pass
		type.Food:
			food_label += value
			pass
		type.Wood:
			wood_label += value
			pass	
