extends StaticBody2D

var totalTime = 5
var currTime
var units = 0

@onready var bar = $ProgressBar
@onready var timer = $Timer


func _ready() -> void:
	currTime = totalTime
	bar.max_value = totalTime
	

func _process(delta: float) -> void:
	if currTime <= 0:
		treeChopped()

func _on_chop_area_body_entered(body: Node2D) -> void:
	if "Knight" in body.name:
		units += 1
		startChopping()

func _on_chop_area_body_exited(body: Node2D) -> void:
	if "Knight" in body.name:
		units -= 1
		if units <= 0:
			timer.stop()

func _on_timer_timeout() -> void:
	var chopSpeed = 1 * units
	currTime -= chopSpeed
	var tween = get_tree().create_tween()
	tween.tween_property(bar, "value", currTime, 0.5).set_trans(Tween.TRANS_LINEAR)
	
func startChopping():
	timer.start()

func treeChopped():
	Game.Wood += 1
	queue_free()
