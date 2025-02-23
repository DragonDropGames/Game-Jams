extends Node

var iron_label: int = 10;
var wood_label: int = 100;

func updateResource(type: Enums.RESOURCES_TYPE, value: int):
	match type:
		Enums.RESOURCES_TYPE.IRON:
			iron_label += value
			pass
		Enums.RESOURCES_TYPE.WOOD:
			wood_label += value
			pass

func add_iron(value: int):
	iron_label += value
	
func add_wood(value: int):
	wood_label += value

func can_consume_wood(value: int) -> bool:
	return wood_label - value > 0

func can_consume_iron(value: int) -> bool:
	return iron_label - value > 0

func consume_iron(value: int):
	if can_consume_iron(value):
		iron_label -= value
		return true
	else:
		return false

func consume_wood(value: int):
	if can_consume_wood(value):
		wood_label -= value
		return true
	else:
		return false
