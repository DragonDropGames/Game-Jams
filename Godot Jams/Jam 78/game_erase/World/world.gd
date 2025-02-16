extends Node2D

const LightTexture = preload("res://Assets/Light.png")
const GRID_SIZE = 16

@onready var fog = $Fog

var display_width = ProjectSettings.get("display/window/size/viewport_width")
var display_height = ProjectSettings.get("display/window/size/viewport_height")

var fogImage = Image.new()
var fogTexture = ImageTexture.new()
var lightImage = LightTexture.get_image()
var light_offset = Vector2(LightTexture.get_width()/2, LightTexture.get_height()/2)



var units = []
var wagons = []
var enemies = []
var resources = []

func _ready():
	load_units()
	load_enemies()
	load_resources()
	
	var fog_image_width = display_width/GRID_SIZE
	var fog_image_height = display_height/GRID_SIZE
	fogImage= Image.create(fog_image_width+1,fog_image_height+1,false,Image.FORMAT_RGBAH)
	fogImage.fill(Color.BLACK)
	lightImage.convert(Image.FORMAT_RGBAH)
	fog.scale *= GRID_SIZE

func _process(delta: float) -> void:
	for wagon in wagons:
		update_fog(wagon.position/GRID_SIZE)
	
func _on_area_selected(object):
	var start = object.start
	var end = object.end
	var area = []
	
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	
	var unitsInArea = get_units_in_area(area)
	updateUnitSelectedStatus(units, false)
	updateUnitSelectedStatus(wagons, false)
	updateUnitSelectedStatus(unitsInArea, true)

func updateUnitSelectedStatus(items, isSelected):
	for item in items:
		item.setSelected(isSelected)

func get_units_in_area(area):
	var unitsInArea = []
	for unit in units:
		if (unit.position.x > area[0].x) and (unit.position.x < area[1].x):
			if (unit.position.y > area[0].y) and (unit.position.y < area[1].y):
				unitsInArea.append(unit)
	
	for wagon in wagons:
		if (wagon.position.x > area[0].x) and (wagon.position.x < area[1].x):
			if (wagon.position.y > area[0].y) and (wagon.position.y < area[1].y):
				unitsInArea.append(wagon)
	
	return unitsInArea

func load_units():
	units = null
	units = get_tree().get_nodes_in_group("Units")
	wagons = get_tree().get_nodes_in_group("Wagons")
	
func load_enemies():
	enemies = null
	enemies = get_tree().get_nodes_in_group("Enemies")
	
func load_resources():
	resources = null
	resources = get_tree().get_nodes_in_group("Resources")
	
func update_fog(new_grid_position):
	
	var light_rect = Rect2(Vector2.ZERO, Vector2(lightImage.get_width(), lightImage.get_height()))
	fogImage.blend_rect(lightImage, light_rect, new_grid_position - light_offset)

	update_fog_image_texture()
	
func update_fog_image_texture():
	fogTexture= ImageTexture.create_from_image(fogImage)
	fog.texture = fogTexture
