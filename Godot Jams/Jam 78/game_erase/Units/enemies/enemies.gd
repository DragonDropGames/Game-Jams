extends CharacterBody2D

class_name EnemyCharacter

enum ENEMY_TYPE { BASIC, MEDIUM, BIGBOY, BOSS }

@export var speed: float
var image: AnimatedSprite2D
var alive = true
var player = null
var aggroed = false
var attack_damage = 10
var attack_frequency = 1
var combat: CombatSystem
const attack_group = "ControllableUnits"
const group_name = "Enemies"

@export var enemy: ENEMY_TYPE
@export var health: float = 100
@export var separation_distance: float = 30.0
@export var neighbor_radius: float = 75.0
@export var max_force: float = 2.0
@export var friction: float = 0.9  # Reduces movement over time to settle

@onready var basicEnemyImage: AnimatedSprite2D = $EnemyCollision/BasicEnemy
@onready var mediumEnemyImage: AnimatedSprite2D = $EnemyCollision/MediumEnemy
@onready var bigBoyImage: AnimatedSprite2D = $EnemyCollision/BigBoy

@onready var aggro_range: Area2D = $AggroRange
@onready var attack_range: Area2D = $AttackRange

var boid := Boid.new()


func _ready():
	add_to_group("Enemies", true)
	
	match enemy:
		ENEMY_TYPE.BASIC:
			speed = 35
			image = basicEnemyImage
			attack_damage = 10
			attack_frequency = 1
			basicEnemyImage.visible = true
			add_to_group("SmallBoys", true)
		ENEMY_TYPE.MEDIUM:
			speed = 25
			image = mediumEnemyImage
			attack_damage = 10
			attack_frequency = 1
			mediumEnemyImage.visible = true
			add_to_group("MediumBoys", true)
		ENEMY_TYPE.BIGBOY:
			speed = 15
			image = bigBoyImage
			attack_damage = 10
			attack_frequency = 1
			bigBoyImage.visible = true
			add_to_group("BigBoys", true)
		ENEMY_TYPE.BOSS:
			speed = 10
	
	aggro_range.body_entered.connect(_on_agro_enter)
	aggro_range.body_exited.connect(_on_agro_exit)
	attack_range.body_entered.connect(_on_attack_range_enter)
	attack_range.body_exited.connect(_on_attack_range_exit)
	
	combat = CombatSystem.new()
	combat.attack_damage = attack_damage
	combat.attack_frequency = attack_frequency
	combat.attack_group = attack_group
	combat.node = self

func _physics_process(delta: float):
	if not alive:
		return
	
	var enemy = combat.enemy
	
	if combat.attacking and enemy:
		image.play('attack')
		combat.attack()
		
		var direction = (enemy.global_position - global_position).normalized()
		velocity = direction * speed
		
	elif aggroed and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		if combat.attacking:
			image.play('attack')
			combat.attack()
		else:
			image.play('run')
	else:
		image.play('idle')
		velocity = Vector2.ZERO

	move_and_slide()

func _on_agro_enter(body):
	if body.is_in_group(attack_group):
		player = body
		aggroed = true

func _on_agro_exit(body):
	if body == player:
		player = null
		aggroed = false

func _on_attack_range_enter(body):
	combat.on_attack_range_enter(body)

func _on_attack_range_exit(body):
	combat.on_attack_range_exit(body)

func _process(delta: float) -> void:
	boid.process_boid(delta, self, speed, group_name)

func _on_health_check_timer_timeout() -> void:
	if health <= 0 and alive:
		die()

func die():
	alive = false
	image.play('die')
	set_physics_process(false)
	set_process(false)
	remove_from_group('ControlableUnits')
	aggro_range.monitoring = false
	attack_range.monitoring = false
	aggro_range.body_entered.disconnect(_on_agro_enter)
	aggro_range.body_exited.disconnect(_on_agro_exit)
	attack_range.body_entered.disconnect(_on_attack_range_enter)
	attack_range.body_exited.disconnect(_on_attack_range_exit)
	
func take_damage(damage: float, body: Node2D) -> bool:
	health -= damage
	
	print("[enemy unit] taking damage", damage, " remaining health ", health)

	_on_health_check_timer_timeout()
	
	if alive:
		combat.being_attacked(body)
	
	return not alive
