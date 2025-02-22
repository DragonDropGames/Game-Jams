extends ControlableUnit

@onready var heroSprite = $CollisionShape2D/Hero

func _ready():
	light_scale = 10
	light_depletion_rate = 0
	speed = 60
	health = 1200
	alive = true
	sprite = heroSprite
	attack_area = $AttackArea
	ready_complete()
