extends Button

var vis:bool = false
var bought:int = 0
var cost = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = !vis


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
