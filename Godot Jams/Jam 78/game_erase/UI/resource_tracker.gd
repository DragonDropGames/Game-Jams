extends Label


var value: String;
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.name
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if name == 'Wood Count':
		value = str(Global_Resources.wood_label)
	if name == 'Iron Count':
		value = str(Global_Resources.iron_label)
	if name == 'Meat Count':
		value = str(Global_Resources.food_label)
		
	text = value
	pass
