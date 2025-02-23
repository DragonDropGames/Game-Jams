extends ControlableUnit

@onready var heroSprite: AnimatedSprite2D = $CollisionShape2D/Hero


func _ready():
	is_hero = true
	light_scale = 20
	light_depletion_rate = 0.5
	speed = 40
	health = 1200
	alive = true
	sprite = heroSprite
	attack_area = $AttackArea
	attack_damage = 10
	attack_frequency = 1
	ready_complete()

func _process(delta: float) -> void:
	if alive && health <= 0:
		get_tree().change_scene_to_file("res://womp_womp.tscn")
