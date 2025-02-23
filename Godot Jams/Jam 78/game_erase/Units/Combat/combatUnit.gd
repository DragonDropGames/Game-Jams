extends ControlableUnit

@export var unit: Enums.UNIT_TYPE

@onready var sword_image: AnimatedSprite2D = $BowArea/BowCollisionShape2D/SwordUnit
@onready var bow_image: AnimatedSprite2D = $SwordArea/SwordCollisionShape2D/BowUnit

func _ready():
	light_scale = 5
	health = 100
	darkness_scaler = .5
	light_depletion_rate = 1
	add_to_group("Units")
	
	match unit: 
		Enums.UNIT_TYPE.SWORD:
			attack_area = $BowArea
			attack_damage = 10
			attack_frequency = 1
			speed = 15
			sprite = sword_image
			sword_image.visible = true
		Enums.UNIT_TYPE.BOW:
			attack_area = $SwordArea
			attack_damage = 25
			attack_frequency = 5
			sprite = bow_image
			bow_image.visible = true
			speed = 10 
	
	ready_complete()
