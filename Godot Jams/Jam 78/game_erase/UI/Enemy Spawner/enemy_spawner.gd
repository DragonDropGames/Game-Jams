extends CharacterBody2D

@onready var spawn_timer = $Timer
var rng = RandomNumberGenerator.new()

@onready var fog = get_node("/root/World/WorldGeneration/Fog_Layer")

@export var spawn_radius: float = 30
@export var min_units: int = 2
@export var max_units: int = 6
@export var map_size: Vector2 = Vector2(256,256) * 16

var spawn_budget: int

func _ready() -> void:
	spawn_budget = rng.randi_range(min_units, max_units)
	spawn_timer.start()

func _on_timer_timeout() -> void:
	if spawn_budget <= 0:
		check_and_spawn_new_spawner()
		queue_free()
		return

	var roll = rng.randf()
	var enemy: Enums.ENEMY_TYPE
	var cost: int
	
	if roll < 0.50:
		enemy = Enums.ENEMY_TYPE.BASIC
		cost = 1
	elif roll < 0.85:
		enemy = Enums.ENEMY_TYPE.MEDIUM
		cost = 2
	else:
		enemy = Enums.ENEMY_TYPE.BIGBOY
		cost = 3

	if spawn_budget >= cost:
		spawn_budget -= cost
		var angle = rng.randf_range(0, TAU)
		var offset = Vector2(cos(angle), sin(angle)) * rng.randf_range(10, spawn_radius)
		var spawn_position = global_position + offset

		if fog.is_safe(spawn_position):
			return
			
		SpawnUnits.spawnEnemy(enemy, spawn_position)
		print("spawned new enemy ", enemy, " ", spawn_position)

	spawn_timer.start()

func check_and_spawn_new_spawner():
	var enemy_count = get_tree().get_nodes_in_group("Enemies").size()

	if enemy_count < 100:
		var new_position = Vector2(rng.randf_range(0, map_size.x), rng.randf_range(0, map_size.y))

		var new_spawner = load("res://UI/Enemy Spawner/enemy_spawner.tscn").instantiate()
		new_spawner.position = new_position

		get_parent().add_child(new_spawner)
