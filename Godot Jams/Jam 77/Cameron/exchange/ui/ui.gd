extends CanvasLayer

@onready var label = $Label
@onready var label2 = $Label2

func _process(delta):
	label.text = "Wood: " + str(Game.Wood)
	label2.text = "Coin: " + str(Game.Coin)
