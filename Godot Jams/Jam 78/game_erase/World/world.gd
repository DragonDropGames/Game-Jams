extends Node2D


var units = []
var wagons = []
var enemies = []
var resources = []

signal update_fog(Vector2)

func _ready():
	load_units()
	load_enemies()
	load_resources()
	connect("update_fog", Callable(get_tree().get_root().get_node("World/WorldGeneration"), "update_fog"))


func _process(delta: float) -> void:
	for wagon in wagons:
		emit_signal("update_fog",wagon.position, wagon.lightScale)
	
func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area = []
	
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	
	var unitsInArea = get_units_in_area(area)
	updateUnitSelectedStatus(units, false)
	updateUnitSelectedStatus(wagons, false)
	updateUnitSelectedStatus(unitsInArea, true)

func updateUnitSelectedStatus(items, isSelected):
	for item in items:
		item.setSelected(isSelected)

func get_units_in_area(area):
	var unitsInArea = []
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				unitsInArea.append(unit)
	
	for wagon in wagons:
		if (wagon.position.x > area[0].x) and (wagon.position.x < area[1].x):
			if (wagon.position.y > area[0].y) and (wagon.position.y < area[1].y):
				unitsInArea.append(wagon)
	
	return unitsInArea

func load_units():
	units = null
	units = get_tree().get_nodes_in_group("Units")
	wagons = get_tree().get_nodes_in_group("Wagons")
	
func load_enemies():
	enemies = null
	enemies = get_tree().get_nodes_in_group("Enemies")
	
func load_resources():
	resources = null
	resources = get_tree().get_nodes_in_group("Resources")
