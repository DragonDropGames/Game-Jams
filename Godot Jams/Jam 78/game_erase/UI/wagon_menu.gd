extends Node2D

var travel = Vector2(0, -150)
var duration = 1
var spread = PI / 2
var _wagon: Node2D

func showMenu(type: Enums.WAGON_TYPE, woodCount: float, wagon: Node2D) -> void:
	_wagon = wagon
	var buildable = $Panel/Buildable
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)
	
	#potentially move this a parameter, being passed in
	position.y = -75
	
	buildable.visible = true
	tween.play()

func _on_sword_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if Game.can_consume_iron(20):
			Game.consume_iron(20)
			SpawnUnits.spawn(Enums.UNIT_TYPE.SWORD, _wagon.position)
		else:
			print("not enough resources")
	
func _on_bow_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if Game.can_consume_iron(10) and Game.can_consume_wood(10):
			Game.consume_iron(10)
			Game.consume_wood(10)
			SpawnUnits.spawn(Enums.UNIT_TYPE.BOW, _wagon.position)
		else:
			print("not enough resources")
			
func _on_main_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.

func _on_resource_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if Game.can_consume_iron(25):
			Game.consume_iron(25)
			SpawnUnits.spawn(Enums.UNIT_TYPE.VILLAGER, _wagon.position)
		else:
			print("not enough resources")
