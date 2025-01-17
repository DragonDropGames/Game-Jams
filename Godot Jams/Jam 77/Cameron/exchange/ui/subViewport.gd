extends SubViewport

@onready var camera = $Camera
var knightBuilding = preload("res://ui/MiniMapSprites/BuildingSprite.tscn")
var resourceBuilding = preload("res://ui/MiniMapSprites/ResourceBuildingSprite.tscn")
var knight = preload("res://ui/MiniMapSprites/KnightSprite.tscn")
var tree = preload("res://ui/MiniMapSprites/TreeSprite.tscn")

var rootPath

func _ready():
	rootPath = get_tree().get_root()
	updateMap()

func _process(delta: float) -> void:
	var cameraPath = get_tree().get_root().get_node("World/Camera")
	camera.position = cameraPath.position / 2 
	camera.zoom = cameraPath.zoom / 5 
	
	updateUnitPos()
	
func updateMap():
	print("called")
	for i in get_node("Other").get_child_count():
		get_node("Other").get_child(i).queue_free()
	
	for i in get_node("Units").get_child_count():
		get_node("Units").get_child(i).queue_free()
		
	genBuildings()
	genUnits()
	genObjects()
	
func genBuildings():
	var buildings = rootPath.get_node('World/Buildings')
	
	for i in buildings.get_child_count():
		var building = buildings.get_child(i)
		var newBuilding
		
		if building.is_in_group("ResourceBuilding"):
			newBuilding = resourceBuilding.instantiate()
		elif building.is_in_group("Building"):
			newBuilding = knightBuilding.instantiate()
			
		get_node("Other").add_child(newBuilding)
		newBuilding.position = building.position / 2

func updateUnitPos():
	var unitsMiniMap = get_node("Units")
	var units = rootPath.get_node("World/Units")
	for i in units.get_child_count():
		unitsMiniMap.get_child(i).position = units.get_child(i).position / 2

func genUnits():
	var units = rootPath.get_node("World/Units")
	
	for i in units.get_child_count():
		var unit = units.get_child(i)
		var newUnit
		
		if unit.is_in_group("Knight"):
			newUnit = knight.instantiate()
		elif unit.is_in_group("Farmer"):
			pass
		
		get_node("Units").add_child(newUnit)
		
func genObjects():
	var objects = rootPath.get_node("World/Objects") 
	
	for i in objects.get_child_count():
		var object = objects.get_child(i)
		var newObject
		
		if object.is_in_group("Tree"):
			newObject = tree.instantiate()
		
		get_node("Other").add_child(newObject)
		newObject.position = object.position / 2
