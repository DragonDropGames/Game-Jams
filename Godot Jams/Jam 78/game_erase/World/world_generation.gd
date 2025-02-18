extends Node2D

const LightTexture = preload("res://Assets/Light.png")
const REVEAL_SIZE = 25

@onready var fog = $Fog

var map_rect: Rect2
var darkness_image = Image.new()
var light_image = LightTexture.get_image()
var light_offset = Vector2(LightTexture.get_width() / 2, LightTexture.get_height() / 2)

var cleared: Array

func _ready() -> void:
	map_rect = Rect2(Vector2(0, 0), get_viewport().size)
	
	fog.scale *= REVEAL_SIZE
	
	darkness_image = Image.create(map_rect.size.x, map_rect.size.y, false, Image.FORMAT_RGBAH)
	darkness_image.fill(Color.BLACK)
	
	light_image.convert(Image.FORMAT_RGBAH)

func update_fog(new_grid_position, light_scale):
	var new_position = new_grid_position / REVEAL_SIZE
	var dist = new_position - light_offset
	var clear_pos = Vector2(floor(dist.x), floor(dist.y))
	
	if !clear_pos in cleared:
		var reveal = Vector2(12, 12)
		
		darkness_image.blend_rect(light_image, Rect2(Vector2.ZERO, reveal), clear_pos)
		
		cleared.append(clear_pos)
	
		update_fog_image_texture()
	
func update_fog_image_texture():
	var fog_image = Image.create(map_rect.size.x, map_rect.size.y, false, Image.FORMAT_RGBAH)
	fog_image.fill(Color(0.0, 0.0, 0.0, 0.5))
	
	var dark = ImageTexture.create_from_image(darkness_image)
	
	fog.texture = ImageTexture.create_from_image(darkness_image)
