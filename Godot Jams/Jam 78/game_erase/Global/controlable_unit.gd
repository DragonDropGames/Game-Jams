extends CharacterBody2D

class_name ControlableUnit

@export var speed: float = 10
@export var health: float = 10
@export var darkness_scaler: float = 0
@export var gathering_resources: float = 0
@export var light_scale: float
@export var light_depletion_rate: int = 0
@export var sprite: AnimatedSprite2D
# COMBAT
@export var attack_area: Area2D
@export var attack_damage: float
@export var attack_frequency: float

@onready var selected_panel: Panel = get_node("SelectedPanel")
@onready var health_bar: TextureProgressBar = get_node("BasicHealthBar")
@onready var hp_label: Label = $Label
@onready var point_light: PointLight2D
@onready var light_collision: CollisionShape2D
@onready var fog = get_node("/root/World/WorldGeneration/Fog_Layer")
@onready var label = get_node("Label")
@onready var target = position
@onready var tourch_scn: Resource = preload("res://Global/Tourch Light/PointLight.tscn")

const group_name = "ControllableUnits"
var in_light := true
var alive := true
var follow_cursor := false
var is_selected := false
var light_timer := Timer.new()
var selected := false

var boid := Boid.new()
var combat: CombatSystem

func ready_complete():
	light_collision = CollisionShape2D.new()
	
	var light_area = Area2D.new()
	light_area.add_child(light_collision)
	add_child(light_area)
	
	point_light = tourch_scn.instantiate()
	
	add_child(point_light)
	
	add_to_group(group_name, true)
	
	light_timer.wait_time = 1.0
	light_timer.one_shot = false
	light_timer.timeout.connect(_on_light_timer)
	add_child(light_timer)
	light_timer.start()
	
	scale_lights()
	fog.clear_fog(light_collision)
	
	if attack_area and attack_damage and attack_frequency:
		attack_area.connect("body_entered", Callable(self, "_on_attack_range_enter"))
		attack_area.connect("body_exited", Callable(self, "_on_attack_range_exit"))
		combat = CombatSystem.new()
		combat.attack_damage = attack_damage
		combat.attack_frequency = attack_frequency
		combat.attack_group = "Enemies"
		combat.node = self

func _physics_process(delta: float) -> void:
	if follow_cursor && is_selected:
		target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 10:
		fog.clear_fog(light_collision)
		update_sprit('run')
		move_and_slide()
	elif gathering_resources:
		update_sprit('collect')
	elif combat and combat.attacking:
		update_sprit('attack')
		combat.attack()
	else:
		update_sprit('idle')

func _process(delta: float) -> void:
	if !in_light:
		die()

		if label:
			label.visible = false

	elif label:
		label.visible = true

	health_bar.visible = health_bar.value != health_bar.max_value

	if health_bar.value <= 0:
		die()
	
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
	if light_scale <= 0.0:
		die()
	elif light_depletion_rate > 0:
		Game.consumeWood()
		light_scale -= light_depletion_rate
		scale_lights()

func _on_light_area_body_entered(body: Node2D) -> void:
	print("[_on_light_area_body_entered]")
	if body.is_in_group("Units"):
		body.in_light = true

func _on_light_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.in_light = false

func set_selected(value: bool):
	is_selected = value
	selected_panel.visible = value

func _on_health_check_timer_timeout() -> void:
	if health <= 0 and alive:
		die()

func scale_lights() -> void:
	if !light_collision:
		return
		
	light_collision.scale = Vector2(light_scale, light_scale)
	point_light.scale = Vector2(light_scale, light_scale)

func update_sprit(name: String) -> void:
	if sprite:
		sprite.play(name)

func die():
	alive = false
	update_sprit("die")
	set_physics_process(false)
	set_process(false)
	remove_from_group('ControlableUnits')
	light_timer.stop()

func take_damage(damage: float, body: Node2D) -> bool:
	if not alive:
		return not alive 

	health -= damage
	print("[controllable unit] taking damage", damage, " remaining health ", health)
	
	_on_health_check_timer_timeout()
	
	if alive:
		combat.being_attacked(body)
	
	return not alive
