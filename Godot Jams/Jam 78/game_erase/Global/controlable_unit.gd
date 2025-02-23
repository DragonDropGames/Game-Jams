extends CharacterBody2D

class_name ControlableUnit

@export var is_hero = false
@export var speed: float = 10
@export var health: float = 10
@export var gathering_resources: bool = false
@export var light_scale: float
@export var light_depletion_rate: float = 1
@export var sprite: AnimatedSprite2D
# COMBAT
@export var attack_area: Area2D
@export var attack_damage: float
@export var attack_frequency: float

@onready var selected_panel: Panel = get_node("SelectedPanel")
@onready var health_bar: ProgressBar = get_node("HealthBar")
@onready var hp_label: Label = $Label
@onready var point_light: PointLight2D

@onready var fog = get_node("/root/World/WorldGeneration/Fog_Layer")
@onready var label = get_node("Label")
@onready var target = position
@onready var tourch_scn: Resource = preload("res://Global/Tourch Light/PointLight.tscn")

const group_name = "ControllableUnits"
var alive := true
var follow_cursor := false
var is_selected := false
var light_timer := Timer.new()
var health_check_timer := Timer.new()
var selected := false
var original_light_scale: float


var boid := Boid.new()
var combat: CombatSystem
var light_collision: CollisionShape2D

func ready_complete():
	set_collision_mask_value(6, true)
	
	original_light_scale = light_scale
	
	var light_area := Area2D.new()
	add_child(light_area)
	
	light_collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()
	shape.radius = light_scale
	light_collision.shape = shape
	light_collision.scale = Vector2.ONE * light_scale
	light_area.add_child(light_collision)
	
	point_light = tourch_scn.instantiate()
	
	add_child(point_light)
	
	add_to_group(group_name, true)
	
	light_timer.wait_time = 10.0
	light_timer.one_shot = false
	light_timer.timeout.connect(_on_light_timer)
	add_child(light_timer)
	light_timer.start()
	
	health_check_timer.wait_time = 1.0
	health_check_timer.one_shot = false
	health_check_timer.timeout.connect(_on_health_check_timer_timeout)
	add_child(health_check_timer)
	health_check_timer.start()
	
	health_bar.min_value = 0
	health_bar.max_value = health
	health_bar.value = health
	
	scale_lights()
	fog.clear_fog(light_collision)
	if attack_area and attack_damage and attack_frequency:
		attack_area.body_entered.connect(_on_attack_range_enter)
		attack_area.body_exited.connect(_on_attack_range_exit)
		combat = CombatSystem.new()
		combat.attack_damage = attack_damage
		combat.attack_frequency = attack_frequency
		combat.attack_group = "Enemies"
		combat.node = self

func _physics_process(delta: float) -> void:
	if follow_cursor && is_selected:
		target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 20:
		fog.clear_fog(light_collision)
		update_sprit('run')
		move_and_slide()
	elif gathering_resources:
		update_sprit('collect')
	elif combat and combat.attacking:
		print("is attacking")
		update_sprit('attack')
		combat.attack()
	else:
		update_sprit('idle')

func _process(delta: float) -> void:
	var safe: bool = fog.is_safe(position)
	
	if label:
		label.visible = safe
	
	if not safe:
		die("not in light")

	health_bar.visible = health_bar.value != health_bar.max_value

	boid.process_boid(delta, self, speed, group_name)

func _on_attack_range_enter(body):
	combat.on_attack_range_enter(body)

func _on_attack_range_exit(body):
	combat.on_attack_range_exit(body)
		
func _input(event):
	if event.is_action_pressed("RightClick"):
		follow_cursor = true
	elif event.is_action_released("RightClick"):
		follow_cursor = false

func _on_light_timer() -> void:
	light_scale -= light_depletion_rate
	
	var diff = original_light_scale - light_scale
	
	if Game.can_consume_wood(diff):
		Game.consume_wood(diff)
		light_scale = original_light_scale
		return
	
	var recieved_wood = false
	
	for w in range(diff):
		recieved_wood = Game.consume_wood(1)
		if recieved_wood == false:
			break
		else:
			light_scale += 1
	
	if not recieved_wood:
		light_scale -= light_depletion_rate
		scale_lights()

func _on_light_area_entered(body: Node2D) -> void:
	if body.is_in_group(group_name):
		body.in_lights.append(self)

func _on_light_area_exited(body: Node2D) -> void:
	if body.is_in_group(group_name):
		body.in_lights.erase(body)

func set_selected(value: bool):
	if alive:
		is_selected = value
		if selected_panel:
			selected_panel.visible = value
	else:
		is_selected = false
		if selected_panel:
			selected_panel.visible = false

func _on_health_check_timer_timeout() -> void:
	if health_bar != null:
		health_bar.value = health
	if health <= 0 and alive:
		die("health check")

func scale_lights() -> void:
	if !light_collision:
		return
	
	if light_scale > 0:
		light_collision.scale = Vector2.ONE * light_scale
		point_light.scale = Vector2.ONE * light_scale
	else:
		light_collision.scale = Vector2.ZERO
		point_light.scale = Vector2.ZERO

func update_sprit(name: String) -> void:
	if sprite:
		sprite.play(name)

func die(reason: String):
	print("Unit Died from ", reason, " ", self)
	alive = false
	update_sprit("die")
	set_physics_process(false)
	remove_from_group('ControlableUnits')
	light_timer.stop()
	health_bar.visible = false
	selected = false
	selected_panel.visible = false
	set_selected(false)
	
	for child in get_children():
		if child is CollisionShape2D:
			child.disabled = true
			
	if attack_area:
		attack_area.monitoring = false
		
	await get_tree().create_timer(0.1).timeout
	set_process(false)

func take_damage(damage: float, body: Node2D) -> bool:
	if not alive:
		return not alive 

	health -= damage
	
	_on_health_check_timer_timeout()
	
	target = body.position
	
	if alive and combat:
		combat.being_attacked(body)
	
	return not alive
