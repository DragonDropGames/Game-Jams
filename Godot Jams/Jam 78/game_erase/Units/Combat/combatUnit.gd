extends ControlableUnit

@export var unit: Enums.UNIT_TYPE

@onready var combatSystem: CombatSystem = $CombatSystem
@onready var sword_image: AnimatedSprite2D = $SwordUnit
@onready var bow_image: AnimatedSprite2D = $BowUnit

func _ready():
	light_scale = 5
	health = 100
	darkness_scaler = .5
	light_depletion_rate = 1
	add_to_group("Units")
	
	match unit: 
		Enums.UNIT_TYPE.SWORD:
			attack_area = $BowArea
			speed = 15
			sprite = sword_image
			sword_image.visible = true
			combatSystem.damageType = Enums.DAMAGE_TYPE.MELEE
			combatSystem.distanceOfAttack = 50
			combatSystem.frequencyOfAttack = 2
			combatSystem.damageValue = 5
			combatSystem.targets = [Enums.TARGET_TYPE.ENEMIES]
			combatSystem._ready()
		Enums.UNIT_TYPE.BOW:
			attack_area = $SwordArea
			sprite = bow_image
			bow_image.visible = true
			speed = 10 
	
	ready_complete()
