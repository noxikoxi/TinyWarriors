extends StaticBody2D

var health:int = 150

func hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()

func _ready():
	Globals.goblin_house = self
	

func getSpawnPosition():
	return $SpawnPoint.global_position
	
