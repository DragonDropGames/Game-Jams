extends CharacterBody2D

class_name ControlableUnit

@export var in_light: bool = true
@export var speed: float = 10
@export var health: float = 10
@export var darkness_scaler: float = 0
@export var gathering_resources: float = 0
@export var light_scale: float
@export var light_depletion_rate: int = 0
@export var is_selected = false
@onready var target = position
@onready var selected_panel: Panel = get_node("SelectedPanel")
@onready var health_bar: TextureProgressBar = get_node("BasicHealthBar")
@onready var hp_label: Label = $Label
@onready var point_light: PointLight2D
@onready var light_collision: CollisionShape2D
@export var follow_cursor = false
@export var sprit: AnimatedSprite2D
@export var alive: bool = true
@onready var fog = get_node("/root/World/WorldGeneration/Fog_Layer")
@onready var label = get_node("Label")

var food_timer = Timer.new()

func ready_complete():
	print("ready_complete called....")
	
	light_collision = CollisionShape2D.new()
	
	var light_area = Area2D.new()
	light_area.add_child(light_collision)
	add_child(light_area)
	
	
	point_light = PointLight2D.new()
	point_light.energy = 1
	
	add_child(point_light)
	
	add_to_group("ControllableUnits", true)
	
	food_timer.wait_time = 10.0
	food_timer.one_shot = false
	food_timer.timeout.connect(_on_timer)
	add_child(food_timer)
	food_timer.start()
	
	scale_lights()
	fog.clear_fog(light_collision)

func _physics_process(delta: float) -> void:
	if alive:
		fog.clear_fog(light_collision)
		
		if follow_cursor && is_selected:
			target = get_global_mouse_position()
		
		velocity = position.direction_to(target) * speed
		
		if position.distance_to(target) > 10:
			update_sprit('run')
			move_and_slide()
		elif gathering_resources:
			update_sprit('collect')
		else:
			update_sprit('idle')

				
func _process(delta: float) -> void:
	if !in_light:
		health -= 10 * darkness_scaler
		
		if label:
			label.visible = false
	elif label:
		label.visible = true
		
	if alive &&  health_bar.value != health_bar.max_value:
		health_bar.visible = true
		
		if health_bar.value <= 0:
			die()
			update_sprit("die")
	else:
		health_bar.visible = false

func _input(event):
	if event.is_action_pressed("RightClick"):
		follow_cursor = true
	elif event.is_action_released("RightClick"):
		follow_cursor = false

func _on_timer() -> void:
	Game.consumeWood()
	
	if light_scale < 5:
		extinguish()
	else:
		light_scale -= light_depletion_rate
		scale_lights()

func _on_light_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.in_light = true

func _on_light_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Units"):
		body.in_light = false

func set_selected(value: bool):
	is_selected = value
	selected_panel.visible = value

func _on_health_check_timer_timeout() -> void:
	if health <= 0:
		self.queue_free()

func extinguish() -> void:
	if light_scale <= 0:
		return

	light_scale = 0
	scale_lights()

func scale_lights() -> void:
	if !light_collision:
		return
		
	light_collision.scale = Vector2(light_scale, light_scale)
	point_light.scale = Vector2(light_scale, light_scale) / 25

func update_sprit(name: String) -> void:
	if sprit:
		sprit.play(name)

func die():
	alive = false
	update_sprit("die")
