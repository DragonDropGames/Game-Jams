extends Node

var combatUnit = preload("res://Units/Combat/combatUnit.tscn")
var resourceUnit = preload("res://Units/Resource Collectors/resourceUnit.tscn")
var enemyUnit = load("res://Units/enemies/enemy.tscn")


func spawn(type: Enums.UNIT_TYPE, position: Vector2) -> void:
	var path = get_tree().get_root().get_node("World/Characters")
	var worldPath = get_tree().get_root().get_node("World")
	
	var unit: ControlableUnit
	if type == Enums.UNIT_TYPE.VILLAGER:
		unit = resourceUnit.instantiate()
	else:
		unit = combatUnit.instantiate()
		unit.unit = type
	
	unit.position = position + Vector2(randi_range(-25, 25), randi_range(-25, 25))
	path.add_child(unit)
	worldPath.load_units()


func spawnEnemy(type: Enums.ENEMY_TYPE, position: Vector2) -> void:
	var enemies_path = get_tree().get_root().get_node_or_null("World/Enemeis")
	var world = get_tree().get_root().get_node_or_null("World")

	var unit = enemyUnit.instantiate()
	unit.enemy = type
	unit.position = position

	enemies_path.add_child(unit)
	world.load_enemies()
