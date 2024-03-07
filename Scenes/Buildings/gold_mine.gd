extends StaticBody2D

signal GoldIncreased(amount)

var active:bool = false
var capacity:int = 0
var max_capacity:int = 6
const goldPerWorker: int = 10

var gold_scene:PackedScene = preload("res://Scenes/Objects/gold.tscn")

func _ready():
	Globals.gold_mine = self
	$Sprite.show()
	$ActiveSprite.hide()
	

func getDoorPosition():
	return $DoorPosition.global_position()


func _on_gold_timer_timeout():
	GoldIncreased.emit(capacity * goldPerWorker)
	var gold = gold_scene.instantiate() as Node2D
	gold.global_position = $GoldSpawn.global_position
	add_child(gold)


func _on_pawn_area_body_entered(body):
	if not active:
		active = true
		$Sprite.hide()
		$ActiveSprite.show()
		$Timers/GoldTimer.start()
	
	if capacity < max_capacity:
		capacity += 1
	body.queue_free()
