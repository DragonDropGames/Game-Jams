extends Node2D

const LightTexture = preload("res://Assets/Light.png")

# grid size to check for updates, this will change how often we clear the fog
# lower number will update more often
const CLEARED_BUFFER: int = 10

@onready var fog = $Fog

var map_rect: Rect2
var darkness_image: Image = Image.new()
var light_image: Image = LightTexture.get_image()
var light_offset: Vector2 = Vector2(LightTexture.get_width() / 2, LightTexture.get_height() / 2)
var cleared: Array = []

func _ready() -> void:
	map_rect = Rect2(Vector2(0, 0), Vector2i(256, 256) * 25)
	
	darkness_image = Image.create(map_rect.size.x, map_rect.size.y, false, Image.FORMAT_RGBAH)
	darkness_image.fill(Color.BLACK)
	
	light_image.convert(Image.FORMAT_RGBAH)

func update_fog(new_grid_position: Vector2, light_scale: Vector2):
	var clear_pos = floor(new_grid_position)
	var check_pos = floor(new_grid_position / CLEARED_BUFFER)
	
	if !check_pos in cleared:
		# Properly scale the light image size based on light_scale
		var scaled_size = Vector2(light_image.get_width(), light_image.get_height()) * light_scale
		var reveal_rect = Rect2(Vector2.ZERO, scaled_size)

		# Create a scaled version of the light image
		var scaled_light = light_image.duplicate()
		scaled_light.resize(scaled_size.x, scaled_size.y, Image.INTERPOLATE_BILINEAR)

		# Center the light image to clear the fog correctly
		var blend_position = clear_pos - scaled_size / 2

		print("clearing fog ", check_pos)

		darkness_image.blend_rect(scaled_light, reveal_rect, blend_position)
		
		cleared.append(check_pos)

		update_fog_image_texture()

func update_fog_image_texture():
	fog.texture = ImageTexture.create_from_image(darkness_image)
