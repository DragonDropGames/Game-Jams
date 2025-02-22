extends ControlableUnit

@export var unit: Enums.UNIT_TYPE

var image: AnimatedSprite2D

@onready var sword_image: AnimatedSprite2D = $SwordUnit
@onready var bow_image: AnimatedSprite2D = $BowUnit

func _ready():
	light_scale = 4
	health = 100
	darkness_scaler = .5
	light_depletion_rate = 0.1
	add_to_group("Units")
	
	match unit: 
		Enums.UNIT_TYPE.SWORD:
			attack_area = $BowArea
			attack_damage = 10
			attack_frequency = 1
			speed = 15
			image = sword_image
			sword_image.visible = true
		Enums.UNIT_TYPE.BOW:
			attack_area = $SwordArea
			attack_damage = 25
			attack_frequency = 5
			image = bow_image
			bow_image.visible = true
			speed = 10 
	
	ready_complete()
