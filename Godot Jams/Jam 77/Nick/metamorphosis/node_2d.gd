extends Node2D

@onready var grow_button: Button = $Control/GrowButton
@onready var enable_auto_button: Button = $PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/EnableAutoButton
@onready var points_label: RichTextLabel = $Control/PointsLabel
@onready var rich_text_label: RichTextLabel = $PanelContainer2/RichTextLabel


@onready var getfirstUpgrade = get_node("PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/First Upgrade")
@onready var first_upgrade: Button = $"PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/First Upgrade"
@onready var second_upgrade: Button = $"PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/Second Upgrade"

@onready var getfirstClickUpgrade = get_node("PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/First Click")
@onready var first_click: Button = $"PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/First Click"
@onready var second_click: Button = $"PanelContainer/MarginContainer/ScrollContainer/UpgradeContainer/Second Click"

var points: float = 0
var AutoEnabled:bool = true
var autoAmount:float = .1
var clickAmount = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var pointTotal = str(points).split(".")
	points_label.text = "[indent][color=gold][font_size=18]Leaves: " + pointTotal[0]
	first_upgrade.text = "First Upgrade: Cost: " + str(getfirstUpgrade.cost) + "\nBought: " + str(getfirstUpgrade.bought)
	first_click.text = "First Click Upgrade: Cost: " + str(getfirstClickUpgrade.cost) + "\nBought: " + str(getfirstClickUpgrade.bought)
	rich_text_label.text = "[font_size=12][indent]Leaves per Second: " + str(autoAmount) +"\nClick Bonus: " + str(getfirstClickUpgrade.bought * .5)

func _on_grow_button_pressed() -> void:
	points += clickAmount


func _on_timer_timeout() -> void:
	if AutoEnabled:
		points += autoAmount # Replace with function body.


func _on_enable_auto_button_pressed() -> void:
	if points >= 1000 and AutoEnabled == false:
		points -= 1000
		autoAmount += 1
		AutoEnabled = !AutoEnabled # Replace with function body.


func _on_first_upgrade_pressed() -> void:
	if points >= getfirstUpgrade.cost:
		getfirstUpgrade.bought += 1
		points -= getfirstUpgrade.cost
		getfirstUpgrade.cost += (getfirstUpgrade.cost * getfirstUpgrade.bought)
		autoAmount += getfirstUpgrade.clicksProvided
		


func _on_first_click_pressed() -> void:
	if points >= getfirstClickUpgrade.cost:
		getfirstClickUpgrade.bought += 1
		points -= getfirstClickUpgrade.cost
		getfirstClickUpgrade.cost += (getfirstClickUpgrade.cost * getfirstClickUpgrade.bought)
		clickAmount += (getfirstClickUpgrade.bought)
