extends ControlableUnit

@onready var workerSprite = $Collision/ResourceUnit
@onready var range = $GatherRange

func _ready():
	speed = 10
	health = 100
	darkness_scaler = 0.5
	sprite = workerSprite
	light_scale = 5.0
	light_depletion_rate = 1.0
	add_to_group("Units")
	add_to_group("Villagers")
	
	ready_complete()

func _on_gather_range_body_entered(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gathering_resources = true
	pass # Replace with function body.


func _on_gather_range_body_exited(body: Node2D) -> void:
	if body.is_in_group('Resource'):
		gathering_resources = false
	pass # Replace with function body.
