extends StaticBody2D

var POP = preload("res://Global/POP.tscn")

@onready var bar = $ProgressBar
@onready var timer = $Timer

var totalTime = 50
var currTime

func _ready() -> void:
	add_to_group("ResourceBuilding", true)
	currTime = totalTime
	bar.max_value = totalTime
	timer.start()
	
func _process(delta: float) -> void:
	if currTime <= 0:
		coinsCollected()

func _on_timer_timeout() -> void:
	currTime -= 1
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", currTime, 0.1).set_trans(Tween.TRANS_QUAD)
	
func coinsCollected():
	Game.Coin += 10
	_ready()
	
	var pop = POP.instantiate()
	pop.show_value(str(10), false)
	add_child(pop)
