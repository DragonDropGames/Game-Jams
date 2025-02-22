extends ControlableUnit

@onready var heroSprite = $CollisionShape2D/Hero

func _ready():
	light_scale = 10
	light_depletion_rate = 0
	speed = 60
	health = 1200
	alive = true
	ready_complete()

func _process(delta: float) -> void:
	if alive &&  healthBar.value != healthBar.max_value:
		healthBar.visible = true
		if healthBar.value <= 0:
			alive = false
			heroSprite.play("die")
	else:
		healthBar.visible = false
		
	
		
func _physics_process(delta: float) -> void:
	if followCursor && isSelected:
		target = get_global_mouse_position()
	
	velocity = position.direction_to(target) * speed
	
	if position.distance_to(target) > 10:
		heroSprite.play('run')
		move_and_slide()
	else:
		heroSprite.play('idle')
		
func setSelected(value):
	isSelected = value
	selectedPanel.visible = value