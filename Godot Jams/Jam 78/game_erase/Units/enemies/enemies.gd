extends CharacterBody2D

enum ENEMY_TYPE { BASIC, MEDIUM, BIGBOY, BOSS }


var speed = 20
var image;
var alive = true

@export var enemy: ENEMY_TYPE
@export var health = 100


@onready var basicEnemyImage = get_node("EnemyCollision/BasicEnemy")
@onready var mediumEnemyImage = get_node("EnemyCollision/MediumEnemy")
@onready var bigBoyImage = get_node("EnemyCollision/BigBoy")


func _ready():
	set_properties()

func _process(delta: float) -> void:
	pass

func set_properties():
	match enemy:
		ENEMY_TYPE.BASIC:
			speed = 30
			image = basicEnemyImage
			basicEnemyImage.visible = true
			add_to_group("SmallBoys", true)
		ENEMY_TYPE.MEDIUM:
			speed = 20
			image = mediumEnemyImage
			mediumEnemyImage.visible = true
			add_to_group("MediumBoys", true)
		ENEMY_TYPE.BIGBOY:
			speed = 10
			image = bigBoyImage
			bigBoyImage.visible = true
			add_to_group("BigBoys", true)
		ENEMY_TYPE.BOSS:
			speed = 15

func _on_health_check_timer_timeout() -> void:
	if health <= 0:
		if alive:
			image.play('die')
			alive = false
