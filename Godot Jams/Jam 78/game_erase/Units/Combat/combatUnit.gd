extends ControlableUnit

@export var unit: Enums.UNIT_TYPE

var image: AnimatedSprite2D

@onready var combatSystem: CombatSystem = $CombatSystem
@onready var sword_image: AnimatedSprite2D = $Collision/SwordUnit
@onready var bow_image: AnimatedSprite2D = $Collision/BowUnit

func _ready():
	light_scale = 4
	health = 100
	darkness_scaler = .5
	light_depletion_rate = 0.1
	add_to_group("Units")
	
	match unit: 
		Enums.UNIT_TYPE.SWORD: 
			speed = 15
			image = sword_image
			sword_image.visible = true
			combatSystem.damageType = Enums.DAMAGE_TYPE.MELEE
			combatSystem.distanceOfAttack = 50
			combatSystem.frequencyOfAttack = 2
			combatSystem.damageValue = 5
			combatSystem.targets = [Enums.TARGET_TYPE.ENEMIES]
			combatSystem._ready()
		Enums.UNIT_TYPE.BOW:
			image = bow_image
			bow_image.visible = true
			speed = 10 

	ready_complete()
