extends ControlableUnit

@export var unit: Enums.UNIT_TYPE

@onready var sword_image: AnimatedSprite2D = $Collision/SwordUnit
@onready var bow_image: AnimatedSprite2D = $Collision/BowUnit

func _ready():
	add_to_group("Units")
	
	light_scale = 5

	match unit: 
		Enums.UNIT_TYPE.SWORD:
			attack_area = $SwordArea
			attack_damage = 20
			speed = 25
			health = 100
			attack_frequency = 1
			sprite = $Collision/SwordUnit
		Enums.UNIT_TYPE.BOW:
			attack_area = $BowArea
			attack_damage = 25
			health = 50
			speed = 30
			attack_frequency = 5
			sprite = $Collision/BowUnit
	
	sprite.visible = true
	
	ready_complete()
