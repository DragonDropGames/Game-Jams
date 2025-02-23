extends Node2D


var units: Array[Node] = []
var controllable_units: Array[Node] = []
var enemies: Array[Node] = []
var resources: Array[Node] = []

@onready var music:AudioStreamPlayer2D = $AudioStreamPlayer2D

func _ready() -> void:
	load_units()
	load_enemies()
	load_resources()
	music.stop()
	print(music.playing)
	music.play()
	print(music.playing)
	print(music.stream.resource_path)

	
	

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clear_selected_units()

func _on_area_selected(object: Camera2D):
	clear_selected_units() 
	
	var start = object.start
	var end = object.end
	var area = []
	
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	load_units()
	
	var unitsInArea = get_units_in_area(area)
	
	updateUnitSelectedStatus(unitsInArea, true)

func updateUnitSelectedStatus(items: Array, is_selected: bool):
	for item in items:
		item.set_selected(is_selected)

func get_units_in_area(area):
	var unitsInArea = []
	
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				unitsInArea.append(unit)
	
	for unit in controllable_units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				unitsInArea.append(unit)
	
	return unitsInArea

func clear_selected_units() -> void:
	updateUnitSelectedStatus(units, false)
	updateUnitSelectedStatus(controllable_units, false)


func load_units():
	controllable_units = get_tree().get_nodes_in_group("ControllableUnits")

func load_enemies():
	enemies = get_tree().get_nodes_in_group("Enemies")
	
func load_resources():
	resources = get_tree().get_nodes_in_group("Resources")
	
