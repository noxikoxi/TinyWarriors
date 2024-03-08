extends CanvasLayer

@onready var gold_label: Label = $BannerGold/TextureRect/HBoxContainer/MarginContainer/Label

signal spawnKnight
signal spawnPawn
signal spawnArcher

func _ready():
	updateGoldText()
	Globals.connect("gold_change", updateGoldText)
	
func updateGoldText():
	gold_label.text = str(Globals.gold)


func _on_knight_button_pressed():
	spawnKnight.emit()

func _on_pawn_button_pressed():
	spawnPawn.emit()

func _on_archer_button_pressed():
	spawnArcher.emit()
