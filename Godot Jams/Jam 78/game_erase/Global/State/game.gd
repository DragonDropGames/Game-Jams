extends Node

static var iron_label: int = 10;
static var wood_label: int = 2;

func updateResource(type: Enums.RESOURCES_TYPE,value):
	match type:
		Enums.RESOURCES_TYPE.IRON:
			iron_label += value
			pass
		Enums.RESOURCES_TYPE.WOOD:
			wood_label += value
			pass

func consumeWood():
	if wood_label > 0:
		wood_label -= 1
		return true
	else:
		return false
