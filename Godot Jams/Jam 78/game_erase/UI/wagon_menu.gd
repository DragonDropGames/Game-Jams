extends Node2D

var travel = Vector2(0, -150)
var duration = 1
var spread = PI / 2
var waggon_position: Vector2

func showMenu(type: Enums.WAGON_TYPE, woodCount: float, wagonPos: Vector2) -> void:
	waggon_position = wagonPos
	var swordWagonBuildable = $Panel/Buildable/Sword
	var bowWagonBuildable = $Panel/Buildable/Bow
	var resourceWagonBuildable = $Panel/Buildable/Resource
	var mainWagonBuildable = $Panel/Buildable/Main
	
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, duration)
	
	#potentially move this a parameter, being passed in
	position.y = -75
	
	match type:
		Enums.WAGON_TYPE.SWORD:
			swordWagonBuildable.visible = true
		Enums.WAGON_TYPE.BOW: 
			bowWagonBuildable.visible = true
		Enums.WAGON_TYPE.RESOURCE:
			resourceWagonBuildable.visible = true
		Enums.WAGON_TYPE.MAIN:
			mainWagonBuildable.visible = true
	
	tween.play()


func _on_sword_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if Game.can_consume_iron(20):
			Game.consume_iron(20)
			SpawnUnits.spawn(Enums.UNIT_TYPE.SWORD, waggon_position)
		else:
			print("not enough resources")
	
func _on_bow_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		if Game.can_consume_iron(2010) and Game.can_consume_wood(10):
			Game.consume_iron(10)
			Game.consume_wood(10)
			SpawnUnits.spawn(Enums.UNIT_TYPE.BOW, waggon_position)
		else:
			print("not enough resources")
			
func _on_main_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.

func _on_resource_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
