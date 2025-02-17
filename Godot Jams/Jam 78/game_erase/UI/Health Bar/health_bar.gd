extends TextureProgressBar

# The 3D character whose health this bar represents
@export var wagon: Wagon

# Camera to calculate screen-space position
#var camera: Camera2D

func _ready():
	## Get the active camera
	#camera = get_viewport().get_camera_3d()
	
	# Set the initial value to a placeholder (e.g., full health)
	if wagon and "maxHealth" in wagon:
		value = wagon.maxHealth
	if wagon and "health" in wagon:
		value = wagon.health

func _process(delta):
	if not wagon:
		return
	
	if wagon and "showingUI" in wagon:
		visible = wagon.showingUI
	# Update health bar value
	if wagon and "health" in wagon:
		value = wagon.health
		
