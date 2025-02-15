extends Camera2D

# Camera config
@export var ZOOM_MARGIN = 0.1

# Unit Selection Variables
var mousePos = Vector2()
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
signal area_selected
signal start_move_selection
@onready var box = get_node("../UI/SelectionPanel")


func _ready():
	connect("area_selected", Callable(get_parent(), "_on_area_selected"))

func _process(delat:float) -> void:
	handleUnitSelection()

func handleUnitSelection():
	if Input.is_action_just_pressed("LeftClick"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
	
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		drawArea()
		
	if Input.is_action_just_released("LeftClick"):
		if startV.distance_to(mousePos) > 20:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			drawArea(false)
			emit_signal("area_selected", self)
		else:
			end = start
			isDragging = false
			drawArea(false)

func _input(event: InputEvent) -> void:
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()
		
func drawArea(s=true):
	box.size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	box.visible = s
	box.position = pos
	box.size *= int(s)
