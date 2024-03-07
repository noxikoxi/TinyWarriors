extends Node2D

var knight_scene: PackedScene = preload("res://Scenes/Units/knight1.tscn")
var pawn_scene: PackedScene = preload("res://Scenes/Units/pawn1.tscn")
var goblin_scene: PackedScene = preload("res://Scenes/Enemies'/goblin.tscn")

func create_knight():
	var knight = knight_scene.instantiate() as CharacterBody2D
	knight.position = $Buildings/Castle.getSpawnPosition()
	$Units.add_child(knight)
	
func create_pawn():
	var pawn = pawn_scene.instantiate() as CharacterBody2D
	pawn.position = $Buildings/Castle.getSpawnPosition()
	$Units.add_child(pawn)
	
func _on_ui_spawn_knight():
	if Globals.gold >= 100:
		create_knight()
		Globals.gold -= 100
		$UI.updateGoldText()


func _on_gold_mine_gold_increased(amount):
	Globals.gold += amount


func _on_ui_spawn_pawn():
	if Globals.gold >= 120:
		create_pawn()
		Globals.gold -= 120
		$UI.updateGoldText()


func _on_goblin_spawn_timeout():
	var goblin = goblin_scene.instantiate() as CharacterBody2D
	goblin.position = $Buildings/GoblinHouse.getSpawnPosition()
	$Enemies.add_child(goblin)


func _on_gold_timer_timeout():
	Globals.gold += 5
