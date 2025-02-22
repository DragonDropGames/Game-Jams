extends CharacterBody2D

# UNIT PROPERTIES
var followCursor = false
@export var isSelected = false
@onready var target = position
@onready var selectedPanel = get_node("SelectedPanel")
@onready var label = get_node("Label")
@export var isInLight = false
@export var alive = true

var image
var FOOD_CONSUMPTION_RATE = 1
@onready var dyingTime = $DyingTime
@onready var timer = $FoodTimer
@onready var combatSystem: CombatSystem = $CombatSystem

# UNIT CONFIG
var speed = 10
var health = 100
var ARMOR_SCALER = .5

@onready var swordImage = get_node("Collision/SwordUnit")
@onready var bowImage = get_node("Collision/BowUnit")
@onready var hp = $BasicHealthBar
@export var unit: Enums.UNIT_TYPE

# BOIDS PARAMETERS
@export var separation_distance: float = 25.0
@export var neighbor_radius: float = 75.0
@export var max_force: float = 2.0
@export var friction: float = 0.9  # Reduces movement over time to settle

func _ready():
	add_to_group("Units")
	setProperties()

func _process(delta: float) -> void:
	if alive:
		if hp.value != hp.max_value:
			hp.visible = true

	if !isInLight:
		label.visible = false
		health -= 10 * ARMOR_SCALER
	else:
		hp.visible = false

func _input(event):
	if event.is_action_pressed("RightClick"):
		followCursor = true
	elif event.is_action_released("RightClick"):
		followCursor = false

func _physics_process(delta: float) -> void:
	match unit: 
		Enums.UNIT_TYPE.SWORD: 
			image = swordImage
		Enums.UNIT_TYPE.BOW:
			image = bowImage

	if followCursor && isSelected:
		target = get_global_mouse_position()

	# **Boids Behavior**
	var boids = get_tree().get_nodes_in_group("Units")
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
			# **Separation - Push away when too close**
			if distance < separation_distance:
				var push_vector = (position - boid.position).normalized()
				var push_strength = (separation_distance - distance) / separation_distance  # Stronger push when closer
				separation_force += push_vector * push_strength * 5.0

			# **Alignment - Match velocity with nearby units**
			alignment_force += boid.velocity

			# **Cohesion - Move toward the center of mass**
			center_of_mass += boid.position
			neighbor_count += 1

	if neighbor_count > 0:
		alignment_force = (alignment_force / neighbor_count).normalized() * speed
		cohesion_force = ((center_of_mass / neighbor_count) - position).normalized() * speed

	# **Apply weighted forces**
	var steer = separation_force * 1.8 + alignment_force * 0.8 + cohesion_force * 1.2
	steer = steer.limit_length(max_force)

	velocity += steer * delta
	velocity = velocity.lerp(Vector2.ZERO, friction * delta)  # Gradually slow down
	velocity = velocity.normalized() * speed if velocity.length() > 1 else Vector2.ZERO

	# **Move & Handle Collisions (Push Effect)**
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal()) * 0.5  # Slight bounce effect to prevent sticking

	if alive:
		if position.distance_to(target) > 10:
			image.play('run')
			move_and_slide()
		else:
			image.play('idle')

func setSelected(value):
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
		print(health)

func _on_in_fog_timer_timeout() -> void:
	if !isInLight:
		label.visible = false
		health -= 10 * ARMOR_SCALER
		hp.value = health
	else:
		label.visible = true

	if health <= 0:
		match unit: 
			Enums.UNIT_TYPE.SWORD: 
				if alive:
					die(swordImage)
			Enums.UNIT_TYPE.BOW:
				if alive:
					die(bowImage)

func die(image):
	alive = false
	image.play("die")
