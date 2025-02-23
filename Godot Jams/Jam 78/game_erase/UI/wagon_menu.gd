extends Node2D

var travel = Vector2(0, -150)
var duration = 1
var spread = PI / 2
var pos

func showMenu(type: Enums.WAGON_TYPE, woodCount: float, wagonPos: Vector2) -> void:
	pos = wagonPos
	var fuelCountLabel = $Panel/Panel/WagonFuel
	var swordWagonBuildable = $Panel/Buildable/Sword
	var bowWagonBuildable = $Panel/Buildable/Bow
	var resourceWagonBuildable = $Panel/Buildable/Resource
	var mainWagonBuildable = $Panel/Buildable/Main
	
	fuelCountLabel.text = str(woodCount) + " / 50"
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
		SpawnUnits.spawn(Enums.UNIT_TYPE.SWORD, pos)
	
func _on_bow_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("LeftClick"):
		SpawnUnits.spawn(Enums.UNIT_TYPE.BOW, pos)
	pass # Replace with function body.

func _on_main_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.

func _on_resource_gui_input(event: InputEvent) -> void:
	pass # Replace with function body.
