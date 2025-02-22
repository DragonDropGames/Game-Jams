extends CharacterBody2D

@onready var spawn_timer = $Timer  # Keep the timer
var rng = RandomNumberGenerator.new()

@export var spawn_radius: float = 50.0  # Distance around spawner
@export var min_units: int = 2
@export var max_units: int = 6
@export var map_size: Vector2 = Vector2(1000, 1000)  # Adjust based on your map size

var spawn_budget: int  # Total spawn value budget

func _ready() -> void:
	# Set a random spawn budget (between 8-20)
	spawn_budget = rng.randi_range(min_units, max_units)
	print("Spawner initialized with budget: ", spawn_budget)

	# Start timer to spawn units periodically
	spawn_timer.start()

func _on_timer_timeout() -> void:
	if spawn_budget <= 0:
		#print("Spawner finished! Checking enemy count...")
		check_and_spawn_new_spawner()  # Check enemy count before deleting
		queue_free()  # Remove spawner when done
		return

	# **Modify chances to make BigBoy rare**
	var roll = rng.randf()  # Random float between 0.0 - 1.0
	var enemy
	var cost
	
	if roll < 0.50:  # 50% chance
		enemy = Enums.ENEMY_TYPE.BASIC
		cost = 1
	elif roll < 0.85:  # 35% chance (50% + 35%)
		enemy = Enums.ENEMY_TYPE.MEDIUM
		cost = 2
	else:  # 15% chance (remaining)
		enemy = Enums.ENEMY_TYPE.BIGBOY
		cost = 3

	# Only spawn if budget allows
	if spawn_budget >= cost:
		spawn_budget -= cost  # Deduct cost
		#print("Spawning ", enemy, " | Remaining budget: ", spawn_budget)

		# **Generate random spawn position in a circle**
		var angle = rng.randf_range(0, TAU)  # Random direction
		var offset = Vector2(cos(angle), sin(angle)) * rng.randf_range(10, spawn_radius)
		var spawn_position = position + offset

		# Spawn the enemy
		SpawnUnits.spawnEnemy(enemy, spawn_position)

	# Restart timer for the next spawn
	spawn_timer.start()

func check_and_spawn_new_spawner():
	# Count all enemies in the "Enemies" group
	var enemy_count = get_tree().get_nodes_in_group("Enemies").size()

	#print("Current enemy count: ", enemy_count)
	
	if enemy_count < 100:
		#print("Enemy count low! Spawning a new spawner...")

		# **Pick a random position in the map**
		var new_position = Vector2(rng.randf_range(0, map_size.x), rng.randf_range(0, map_size.y))

		# Create a new spawner at this position
		var new_spawner = load("res://UI/Enemy Spawner/enemy_spawner.tscn").instantiate()
		new_spawner.position = new_position

		# Add the new spawner to the scene
		get_parent().add_child(new_spawner)
