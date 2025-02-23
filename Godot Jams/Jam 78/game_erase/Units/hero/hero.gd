extends ControlableUnit

@onready var heroSprite: AnimatedSprite2D = $CollisionShape2D/Hero
@onready var main_health_bar: TextureProgressBar = get_tree().get_root().get_node("World/UI/HeroHealthBar")

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
	
	main_health_bar.max_value = health
	ready_complete()

func _process(delta: float) -> void:
	if not alive:
		get_tree().change_scene_to_file("res://womp_womp.tscn")
	else:
		main_health_bar.value = health
		
