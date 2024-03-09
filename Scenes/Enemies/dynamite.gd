extends Area2D

@export var speed:int = 600
var direction:Vector2
var damage:int = 10
var explosion_range:int = 100

func _ready():
	$AnimatedSprite2D.scale = Vector2(1, 1)

func _process(delta):
	rotation_degrees += 500 * delta
	position += direction * delta * speed

func _on_body_entered(body):
	$AnimatedSprite2D.play("explosion")
	speed = 1
	
func _on_animated_sprite_2d_animation_changed():
	$AnimatedSprite2D.scale = Vector2(0.5, 0.5)
	for entity in get_tree().get_nodes_in_group("Units") + get_tree().get_nodes_in_group("Goblins"):
			if entity.global_position.distance_to(global_position) <= explosion_range:
				if "hit" in entity:
					entity.hit(damage)
	


func _on_animated_sprite_2d_animation_finished():
	queue_free()
