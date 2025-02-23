extends ControlableUnit

@export var collection_interval: float = 2.0

@onready var workerSprite = $Collision/ResourceUnit
@onready var range = $GatherRange
@onready var tile_map: TileMapLayer = get_node("/root/World/WorldGeneration/Collision Layer")

const tree_coords = Vector2i(4, 6)
var time_since_last_collect: float = 0.0
var gathering_at :Vector2i
var mouseEntered = false

func _ready():
	speed = 50
	health = 100
	sprite = workerSprite
	light_scale = 5.0
	add_to_group("Villagers")
	
	# Go to nearest tree area
	#target = get_closest_tree_tile()
	#velocity = position.direction_to(target) * speed
	#move_and_slide()
	
	ready_complete()
	
func _process(delta: float) -> void:
	time_since_last_collect += delta
	var tree_tiles = get_closest_tree_tile(2)
	
	var distance = position.distance_to(target)
	
	if tree_tiles == Vector2.ZERO:
		gathering_resources = false
		return
	
	if distance < 40:
		target = position
		gathering_resources = true
		
		if time_since_last_collect >= collection_interval:
			Game.updateResource(Enums.RESOURCES_TYPE.WOOD, 10)
			time_since_last_collect = 0.0
	else:
		gathering_resources = false
	
func _on_gather_range_body_entered(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gathering_resources = true
		sprite.play('collect')

func _on_gather_range_body_exited(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gathering_resources = false
		sprite.play('idle')

func get_closest_tree_tile(search_radius: int) -> Vector2:
	if not tile_map:
		return Vector2.ZERO
		
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

func _on_interaction_panel_mouse_entered() -> void:
	mouseEntered = true

func _on_interaction_panel_mouse_exited() -> void:
	mouseEntered = false

func _on_interaction_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and alive:
		if mouseEntered:
			if not is_selected:
				set_selected(true)
			else:
				set_selected(false)
