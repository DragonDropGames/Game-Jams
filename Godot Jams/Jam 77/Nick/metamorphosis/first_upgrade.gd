extends Button

var vis:bool = true
var bought:int = 0;
var clicksProvided:float = .1
var cost:int = (35 * (bought +1))
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = vis


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
