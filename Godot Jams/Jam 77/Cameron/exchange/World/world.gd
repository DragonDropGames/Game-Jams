extends Node2D

var units = []

func _ready():
	get_units()

func get_units():
	units = null
	units = get_tree().get_nodes_in_group("Units")

func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	#print(area)
	var unitsInArea = get_units_in_area(area)
	#print(unitsInArea)
	for unit in units:
		print(unit.position)
		unit.set_selected(false)
		
	for unit in unitsInArea:
		unit.set_selected(!unit.selected)
	
func get_units_in_area(area):
	var unitsInArea = []
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				unitsInArea.append(unit)
	return unitsInArea
