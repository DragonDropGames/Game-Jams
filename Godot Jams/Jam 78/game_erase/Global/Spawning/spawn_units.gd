extends Node

var combatUnit = preload("res://Units/Combat/combatUnit.tscn")
var enemyUnit = preload("res://Units/enemies/enemy.tscn")


func spawn(type: Enums.UNIT_TYPE, position: Vector2) -> void:
	var path = get_tree().get_root().get_node("World/Characters")
	var worldPath = get_tree().get_root().get_node("World")
	var unit = combatUnit.instantiate()
	
	unit.unit = type
	unit.position = position + Vector2(randi_range(-25, 25), randi_range(-25, 25))
	path.add_child(unit)
	worldPath.load_units()


func spawnEnemy(type: Enums.ENEMY_TYPE, position: Vector2) -> void:
	var enemies_path = get_tree().get_root().get_node_or_null("World/Enemies")
	var world = get_tree().get_root().get_node_or_null("World")

	# Ensure the path exists
	if not enemies_path or not world:
		return
	
	# Create the enemy instance
	var unit = enemyUnit.instantiate()
	unit.enemy = type
	unit.position = position
	
	# Add to scene
	enemies_path.add_child(unit)
	world.load_enemies()
