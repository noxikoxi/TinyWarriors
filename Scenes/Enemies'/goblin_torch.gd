extends CharacterBody2D

@export var health:int = 20

func hit(damage):
	health -= damage
	if health <= 0:
		queue_free()
