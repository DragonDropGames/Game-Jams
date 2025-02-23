extends ControlableUnit

@onready var heroSprite: AnimatedSprite2D = $CollisionShape2D/Hero

func _ready():
	light_scale = 20
	light_depletion_rate = 0.5
	speed = 60
	health = 1200
	alive = true
	sprite = heroSprite
	attack_area = $AttackArea
	attack_damage = 10
	attack_frequency = 1
	ready_complete()
