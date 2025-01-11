extends Node

var Wood = 0

@onready var spawn = preload("res://Global/SpawnUnit.tscn")

func spawnUnit(pos):
	var path = get_tree().get_root().get_node("World/UI")
	
	var isOpen = false
	for i in path.get_child_count():
		if "SpawnUnit"  in path.get_child(i).name:
			isOpen = true
	
	if not isOpen:
		var spawnUnit = spawn.instantiate()
		spawnUnit.spawnLocation = pos
		path.add_child(spawnUnit)
	
	
