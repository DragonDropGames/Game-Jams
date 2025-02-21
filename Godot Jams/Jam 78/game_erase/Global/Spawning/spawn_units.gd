extends Node

var combatUnit = preload("res://Units/Combat/combatUnit.tscn")


func spawn(type: Enums.UNIT_TYPE, position: Vector2) -> void:
	var path = get_tree().get_root().get_node("World/WorldNodes/Units")
	var worldPath = get_tree().get_root().get_node("World")
	var unit = combatUnit.instantiate()
	
	unit.unit = type
	unit.position = position
	unit._ready()
	path.add_child(unit)
	worldPath.load_units()
