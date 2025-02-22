extends CharacterBody2D



# ALL UNIT PROPERTIES
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
@onready var label = get_node("Label")
@export var isInLight = false
var FOOD_CONSUMPTION_RATE = 1
@onready var timer = $FoodTimer
@onready var combatSystem: CombatSystem = $CombatSystem

# UNIT CONFIG
var speed = 10
var health = 100
var ARMOR_SCALER = .5
@export var unit: Enums.UNIT_TYPE
@onready var swordImage = get_node("Collision/SwordUnit")
@onready var bowImage = get_node("Collision/BowUnit")

func _ready():
	add_to_group("Units")
	timer.start()
	setProperties()

func _process(delta: float) -> void:
	if health <= 0:
		self.queue_free()
		
	if !isInLight:
		label.visible = false
		health -= 10 * ARMOR_SCALER
	else:
		label.visible = true
	
func _input(event):
	if event.is_action_pressed("RightClick"):
		followCursor = true
	elif event.is_action_released("RightClick"):
		followCursor = false

func _physics_process(delta: float) -> void:
	if followCursor && isSelected:
		target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 10:
		move_and_slide()

func set_selected(value):
	isSelected = value
	selectedPanel.visible = value

func setProperties():
	match unit: 
		Enums.UNIT_TYPE.SWORD: 
			swordImage.visible = true
			speed = 15
			combatSystem.damageType = Enums.DAMAGE_TYPE.MELEE
			combatSystem.distanceOfAttack = 50
			combatSystem.frequencyOfAttack = 2
			combatSystem.damageValue = 5
			combatSystem.targets = [Enums.TARGET_TYPE.ENEMIES]
			combatSystem._ready()
		Enums.UNIT_TYPE.BOW:
			bowImage.visible = true
			speed = 10 
	
func _on_timer_timeout() -> void:
	var foodConsumed = Game.consumeFood()
	if !foodConsumed:
		health -= 10
