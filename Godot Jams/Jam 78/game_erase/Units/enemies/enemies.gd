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

@export var enemy: ENEMY_TYPE
@export var health = 100
@export var separation_distance: float = 30.0
@export var neighbor_radius: float = 75.0
@export var max_force: float = 2.0
@export var friction: float = 0.9  # Reduces movement over time to settle

@onready var basicEnemyImage = $EnemyCollision/BasicEnemy
@onready var mediumEnemyImage = $EnemyCollision/MediumEnemy
@onready var bigBoyImage = $EnemyCollision/BigBoy

		
		
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
	
	$AgroRange.connect("body_entered", Callable(self, "_on_agro_enter"))
	$AgroRange.connect("body_exited", Callable(self, "_on_agro_exit"))
	$AttackRange.connect("body_entered", Callable(self, "_on_attack_range_enter"))
	$AttackRange.connect("body_exited", Callable(self, "_on_attack_range_exit"))
	
	combat = CombatSystem.new()
	combat.attack_damage = attack_damage
	combat.attack_frequency = attack_frequency
	combat.attack_group = "ControlableUnit"

func _physics_process(delta: float):
	if not alive:
		return
	
	if aggroed and player:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		
		if combat.attacking:
			image.play('attack')
		else:
			image.play('run')
	else:
		image.play('idle')
		velocity = Vector2.ZERO

	move_and_slide()

func _on_agro_enter(body):
	if body.is_in_group("ControlableUnits"):
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
	if not alive:
		return  # Don't process movement if dead

	var boids = get_tree().get_nodes_in_group("Enemies")
	var separation_force = Vector2.ZERO
	var alignment_force = Vector2.ZERO
	var cohesion_force = Vector2.ZERO

	var neighbor_count = 0
	var center_of_mass = Vector2.ZERO

	for boid in boids:
		if boid == self or not boid.alive:
			continue

		var distance = position.distance_to(boid.position)
		if distance < neighbor_radius:
			# **Separation (Push Force)**
			if distance < separation_distance:
				var push_vector = (position - boid.position).normalized()
				var push_strength = (separation_distance - distance) / separation_distance  # Scale push force
				separation_force += push_vector * push_strength * 5.0  # Adjust multiplier for strength

			# **Alignment (Match Direction)**
			alignment_force += boid.velocity

			# **Cohesion (Move Toward Center of Group)**
			center_of_mass += boid.position
			neighbor_count += 1

	if neighbor_count > 0:
		alignment_force = (alignment_force / neighbor_count).normalized() * speed
		cohesion_force = ((center_of_mass / neighbor_count) - position).normalized() * speed

	# **Combine Forces**
	var steer = separation_force * 1.8 + alignment_force * 0.8 + cohesion_force * 1.2
	steer = steer.limit_length(max_force)

	velocity += steer * delta
	velocity = velocity.lerp(Vector2.ZERO, friction * delta)  # Gradually slow down
	velocity = velocity.normalized() * speed if velocity.length() > 1 else Vector2.ZERO

	# **Move & Handle Collisions (Push Effect)**
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.5  # Bounce effect to avoid getting stuck

func _on_health_check_timer_timeout() -> void:
	if health <= 0 and alive:
		image.play('die')
		alive = false
		set_physics_process(false)
		remove_from_group("Enemies")
		

func take_damage(damage: float) -> bool:
	health -= damage
	
	if health <= 0 and alive:
		image.play('die')
		alive = false
		set_physics_process(false)
		remove_from_group("Enemies")
	
	return not alive
