extends CanvasLayer

@onready var gold_label: Label = $Banner/GoldCounter/HBoxContainer/MarginContainer/Label

func _ready():
	updateGoldText()
	
func updateGoldText():
	gold_label.text = str(Globals.gold)
