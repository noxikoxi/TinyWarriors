extends StaticBody2D

var health:int = 200

func hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()

func _ready():
	Globals.castle = self

func getSpawnPosition():
	return $SpawnPoint.global_position
