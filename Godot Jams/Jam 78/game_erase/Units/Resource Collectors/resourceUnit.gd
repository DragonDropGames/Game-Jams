extends ControlableUnit

@onready var workerSprite = $Collision/ResourceUnit
@onready var range = $GatherRange
@onready var tile_map: TileMapLayer = get_node("/root/World/WorldGeneration/Collision Layer")

const tree_coords = Vector2i(4, 6)
@export var search_radius: int = 15
@export var layer_index: int = 0

func _ready():
	speed = 10
	health = 100
	darkness_scaler = 0.5
	sprite = workerSprite
	light_scale = 5.0
	light_depletion_rate = 1.0
	add_to_group("Villagers")
	
	# Go to nearest tree area
	#target = get_closest_tree_tile()
	#velocity = position.direction_to(target) * speed
	#move_and_slide()
	
	ready_complete()
	
func _on_gather_range_body_entered(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gathering_resources = true
		sprite.play('collect')

func _on_gather_range_body_exited(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gathering_resources = false
		sprite.play('idle')

func get_closest_tree_tile() -> Vector2:
	var player_tile: Vector2 = tile_map.local_to_map(position)
	var x_radius = range(player_tile.x)
	var y_radius = range(player_tile.y)
	var min_distance: float = INF
	var closest_tile: Vector2
	
	for x in range(-search_radius, search_radius + 1):
		for y in range(-search_radius, search_radius + 1):
			var tile_pos = player_tile + Vector2(x, y)
			var source_id = tile_map.get_cell_source_id(tile_pos)

			if source_id != -1:
				var atlas_coords = tile_map.get_cell_atlas_coords(tile_pos)
				if atlas_coords == tree_coords:
					var world_pos = tile_map.map_to_local(tile_pos)
					var distance = global_position.distance_to(world_pos)

					if distance < min_distance:
						min_distance = distance
						closest_tile = tile_pos

	return closest_tile
