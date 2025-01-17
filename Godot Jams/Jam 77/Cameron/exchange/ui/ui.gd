extends CanvasLayer

@onready var label = $Resources/Wood/WoodLabel
@onready var label2 = $Resources/Coin/CoinLabel

@onready var buildingRef = preload("res://structures/buildings/building.tscn")
@onready var buildingSelected = $Build/Building/Selected

var clickPos = Vector2()

func _process(delta):
	label.text = str(Game.Wood)
	label2.text =  str(Game.Coin)

func isSomethingSelected() -> bool:
	return buildingSelected.visible

func placeItem() -> void:
	var buildingPath = get_tree().get_root().get_node("World/Buildings")
	if buildingSelected.visible:
		var building = buildingRef.instantiate()
		buildingPath.add_child(building)
		building.position = clickPos
	else:
		pass

func unselect() -> void:
	buildingSelected.visible = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		#clickPos = get_global_mouse_position()
		if isSomethingSelected():
			placeItem()
	elif event.is_action_pressed("Right Click"):
		clickPos = null
		if isSomethingSelected():
			unselect()
		
func _on_building_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("Left Click"):
		buildingSelected.visible = true
		print("selected building")
