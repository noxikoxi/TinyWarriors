extends Area2D

@export var speed:int = 800
var direction:Vector2
var damage:int = 8

func _process(delta):
	position += direction * delta * speed

func _on_body_entered(body):
	if "hit" in body:
		body.hit(damage)
	queue_free()
