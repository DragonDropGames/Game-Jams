extends Node

static var iron_label: int = 10;
static var wood_label: int = 10;
static var food_label: int = 10;

func updateResource(type: Enums.RESOURCES_TYPE,value):
	match type:
		Enums.RESOURCES_TYPE.IRON:
			iron_label += value
			pass
		Enums.RESOURCES_TYPE.FOOD:
			food_label += value
			pass
		Enums.RESOURCES_TYPE.WOOD:
			wood_label += value
			pass

func consumeFood():
	if food_label > 0:
		food_label -= 1
		return true
	else:
		return false

func consumeWood():
	pass
