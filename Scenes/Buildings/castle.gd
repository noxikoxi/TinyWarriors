extends StaticBody2D

var health:int = 200

func hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()

func _ready():
	Globals.castle = self

func getSpawnPosition():
	return $SpawnPoints.get_children()[randi_range(0, 4)].global_position
