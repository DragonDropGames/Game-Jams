extends Node2D
class_name CombatSystem


# COMBAT SYSTEM CONFIG
@export var damageType: Enums.DAMAGE_TYPE
@export var distanceOfAttack: float
@export var frequencyOfAttack: float
@export var damageValue: float
@export var targets: Array

# COMBAT SYSTEM NODES
@onready var collision: CollisionShape2D = $CombatRange/CollisionShape2D
@onready var combatTimer = $CombatTimer

# COMBAT SYSTEM VARIABLES
var targetGroups: Array[String]
var isTargetInRange = false
var targetToAttack: Node2D

func _ready() -> void:
	collision.shape.radius = distanceOfAttack
	combatTimer.wait_time = frequencyOfAttack
	for target in targets:
		targetGroups.append(Enums.convertTargetTypeToGroupName(target))

func _on_combat_timer_timeout() -> void:
	if isTargetInRange:
		targetToAttack.health -= damageValue

func _on_combat_range_body_entered(body: Node2D) -> void:
	for target in targetGroups:
		if body.is_in_group(target):
			if targetToAttack == null:
				targetToAttack = body
			isTargetInRange = true
			combatTimer.start()
			
func _on_combat_range_body_exited(body: Node2D) -> void:
	for target in targetGroups:
		if body.is_in_group(target):
			isTargetInRange = false
			if targetToAttack != null:
				targetToAttack = null
			combatTimer.stop()
