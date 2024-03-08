extends Node2D

var knight_scene: PackedScene = preload("res://Scenes/Units/knight.tscn")
var pawn_scene: PackedScene = preload("res://Scenes/Units/pawn.tscn")
var archer_scene: PackedScene = preload("res://Scenes/Units/archer.tscn")

var goblin_scene: PackedScene = preload("res://Scenes/Enemies/goblin.tscn")

var skull_scene: PackedScene = preload("res://Scenes/Objects/skull.tscn")
var arrow_scene: PackedScene = preload("res://Scenes/Units/arrow.tscn")

func spawn_skull(position):
	var skull = skull_scene.instantiate() as AnimatedSprite2D
	skull.position = position
	$Decorations.add_child(skull)

func create_knight():
	var knight = knight_scene.instantiate() as CharacterBody2D
	knight.position = $Buildings/Castle.getSpawnPosition()
	knight.connect("spawnSkull", spawn_skull)
	$Units.add_child(knight)
	
func create_pawn():
	var pawn = pawn_scene.instantiate() as CharacterBody2D
	pawn.position = $Buildings/Castle.getSpawnPosition()
	pawn.connect("spawnSkull", spawn_skull)
	$Units.add_child(pawn)
	
func create_archer():
	var archer = archer_scene.instantiate() as CharacterBody2D
	archer.position = $Buildings/Castle.getSpawnPosition()
	archer.connect("spawnSkull", spawn_skull)
	archer.connect("spawnArrow", spawn_arrow)
	$Units.add_child(archer)
	
	
func spawn_arrow(postion, direction):
	var arrow = arrow_scene.instantiate() as Area2D
	arrow.position = postion
	arrow.rotation_degrees = rad_to_deg(direction.angle())
	arrow.direction = direction
	$Projectiles.add_child(arrow)
	
func _on_ui_spawn_knight():
	if Globals.gold >= Globals.knight_cost:
		create_knight()
		Globals.gold -= Globals.knight_cost
		$UI.updateGoldText()


func _on_gold_mine_gold_increased(amount):
	Globals.gold += amount


func _on_ui_spawn_pawn():
	if Globals.gold >= Globals.pawn_cost:
		create_pawn()
		Globals.gold -= Globals.pawn_cost
		$UI.updateGoldText()


func _on_goblin_spawn_timeout():
	var goblin = goblin_scene.instantiate() as CharacterBody2D
	goblin.position = $Buildings/GoblinHouse.getSpawnPosition()
	goblin.connect("spawnSkull", spawn_skull)
	$Enemies.add_child(goblin)


func _on_gold_timer_timeout():
	Globals.gold += 5


func _on_ui_spawn_archer():
	if Globals.gold >= Globals.archer_cost:
		create_archer()
		Globals.gold -= Globals.archer_cost
		$UI.updateGoldText()
