extends ControlableUnit

@onready var heroSprite: AnimatedSprite2D = $CollisionShape2D/Hero
@onready var main_health_bar: TextureProgressBar = get_tree().get_root().get_node("World/UI/HeroHealthBar")
var mouseEntered = false

func _ready():
	is_hero = true
	light_scale = 20
	light_depletion_rate = 0.5
	speed = 40
	health = 1200
	alive = true
	sprite = heroSprite
	attack_area = $AttackArea
	attack_damage = 30
	attack_frequency = 1
	
	main_health_bar.max_value = health
	ready_complete()

func _process(delta: float) -> void:
	if not alive:
		get_tree().change_scene_to_file("res://womp_womp.tscn")
	else:
		main_health_bar.value = health
		
func _on_interaction_panel_mouse_entered() -> void:
	mouseEntered = true

func _on_interaction_panel_mouse_exited() -> void:
	mouseEntered = false

func _on_interaction_panel_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick") and alive:
		if mouseEntered:
			if not is_selected:
				set_selected(true)
			else:
				set_selected(false)
