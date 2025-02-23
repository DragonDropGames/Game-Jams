extends Camera2D

# Camera config
@export var ZOOM_MARGIN = 0.1
@export var SPEED = 20.0

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

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0
@export var drag_sensitivity: float = 1.0  # Adjust for smoother dragging

var dragging: bool = false

func _ready():
	self.zoom = Vector2(1,1)
	connect("area_selected", Callable(get_parent(), "_on_area_selected"))

func _process(delta:float) -> void:
	handleUnitSelection()
	handleCameraMovement(delta)

func handleCameraMovement(delta: float) -> void:
	var inputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	if position.x >= self.limit_left && position.x < self.limit_right:
		position.x = lerp(position.x, position.x + (inputX * SPEED * zoom.x), SPEED * delta)
	
	if position.y >= self.limit_top && position.x < self.limit_bottom:
		position.y = lerp(position.y, position.y + (inputY * SPEED * zoom.y), SPEED * delta)

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

func _unhandled_input(event):
# Zooming
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom = (zoom + Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom = (zoom - Vector2(zoom_speed, zoom_speed)).clamp(Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
		elif event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed  # Start or stop dragging

	# Dragging (smooth movement)
	elif event is InputEventMouseMotion and dragging:
		# Adjust the dragging speed by dividing the motion by the zoom level to counter the zoom effect
		position -= event.relative * drag_sensitivity / zoom.x
