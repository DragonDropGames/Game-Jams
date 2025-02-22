extends Node2D
class_name CombatSystem

# COMBAT SYSTEM CONFIG
@export var attack_damage: float = 10
@export var attack_frequency: float = 1
@export var attack_group: String

var combat_timer := Timer.new()
var enemy = null
var attacking = false
var _counter: float = 0

func attack() -> void:
	if _counter < attack_frequency:
		_counter += 0.1
		return
	
	_counter = 0
	
	if enemy and attacking:
		var killed = enemy.take_damage(attack_damage)  # Ensure enemy has `take_damage()`
		if killed:
			enemy = null
			attacking = false
		

func on_attack_range_enter(body: Node2D):
	if body.is_in_group(attack_group):
		enemy = body
		attacking = true
		_counter = 0

func on_attack_range_exit(body: Node2D):
	if body == enemy:
		enemy = null
		attacking = false
		_counter = 0
		
