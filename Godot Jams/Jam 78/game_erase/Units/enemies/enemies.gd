extends CharacterBody2D

class_name EnemyCharacter

enum ENEMY_TYPE { BASIC, MEDIUM, BIGBOY, BOSS }

@export var speed: float
var image: AnimatedSprite2D
var alive = true
var player = null
var aggroed = false
var attack_damage: int
var attack_frequency: int
var combat: CombatSystem
const attack_group = "ControllableUnits"
const group_name = "Enemies"

@export var enemy: ENEMY_TYPE
@export var health: float = 100

@onready var collision_shape: CollisionShape2D = $EnemyCollision

@onready var basicEnemyImage: AnimatedSprite2D = $EnemyCollision/BasicEnemy
@onready var mediumEnemyImage: AnimatedSprite2D = $EnemyCollision/MediumEnemy
@onready var bigBoyImage: AnimatedSprite2D = $EnemyCollision/BigBoy

@onready var aggro_range: Area2D = $AggroRange
@onready var attack_range: Area2D = $AttackRange
@onready var health_bar: ProgressBar = $HealthBar

var boid := Boid.new()

func _ready():
	set_collision_mask_value(6, false)

	add_to_group("Enemies", true)
	match enemy:
		ENEMY_TYPE.BASIC:
			speed = 35
			image = basicEnemyImage
			attack_damage = 10
			attack_frequency = 1
			basicEnemyImage.visible = true
			add_to_group("SmallBoys", true)
			health = 100
		ENEMY_TYPE.MEDIUM:
			speed = 25
			image = mediumEnemyImage
			attack_damage = 10
			attack_frequency = 1
			mediumEnemyImage.visible = true
			add_to_group("MediumBoys", true)
			health = 50
		ENEMY_TYPE.BIGBOY:
			speed = 10
			image = bigBoyImage
			attack_damage = 20
			attack_frequency = 1
			bigBoyImage.visible = true
			add_to_group("BigBoys", true)
			health = 100
		ENEMY_TYPE.BOSS:
			speed = 10
			attack_damage = 30
			health = 200
	
	aggro_range.body_entered.connect(_on_agro_enter)
	aggro_range.body_exited.connect(_on_agro_exit)
	attack_range.body_entered.connect(_on_attack_range_enter)
	attack_range.body_exited.connect(_on_attack_range_exit)
	
	combat = CombatSystem.new()
	combat.attack_damage = attack_damage
	combat.attack_frequency = attack_frequency
	combat.attack_group = attack_group
	combat.node = self
	
	health_bar.value = health

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

func die():
	alive = false
	image.play('die')
	health_bar.visible = false
	set_physics_process(false)
	set_process(false)
	remove_from_group('ControlableUnits')
	aggro_range.monitoring = false
	attack_range.monitoring = false
	aggro_range.body_entered.disconnect(_on_agro_enter)
	aggro_range.body_exited.disconnect(_on_agro_exit)
	attack_range.body_entered.disconnect(_on_attack_range_enter)
	attack_range.body_exited.disconnect(_on_attack_range_exit)
	collision_shape.disabled = true
	
func take_damage(damage: float, body: Node2D) -> bool:
	health -= damage
	health_bar.value = health
	
	if health <= 0:
		die()
	

	if alive:
		combat.being_attacked(body)
	
	return not alive
