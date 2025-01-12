extends Node2D

@onready var unitRef = preload("res://units/Knight.tscn")

var spawnLocation = Vector2(300, 300)

func _on_yes_pressed() -> void:
	var unitPath = get_tree().get_root().get_node("World/Units")
	var worldPath = get_tree().get_root().get_node("World")
	var miniMap = get_tree().get_root().get_node("World/UI/MiniMap/SubViewportContainer/SubViewport")
	var unit = unitRef.instantiate()
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var randomPosX = rng.randi_range(-100, 100)
	var randomPosY = rng.randi_range(-100, 100)
	unit.position = spawnLocation + Vector2(randomPosX, randomPosY)
	unit.name = "Knight"
	unitPath.add_child(unit)
	worldPath.get_units()
	miniMap._ready()

func _on_no_pressed() -> void:
	var buildingsPath = get_tree().get_root().get_node("World/Buildings")
	for i in buildingsPath.get_child_count():
		var building = buildingsPath.get_child(i)
		if building.is_in_group("Building"):
			if building.selected:
				building.selected = false
	queue_free()
