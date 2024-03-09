extends CharacterBody2D

var active:bool = false
var speed:int = 300
var target: CharacterBody2D = null
var explosion_range:int = 200
var damage:int = 30 

func _ready():
	$Sprite2D.show()
	$AnimatedSprite2D.hide()
	$AnimatedSprite2D.scale = Vector2(1, 1)
	$NavigationAgent2D.path_desired_distance = 8.0
	$NavigationAgent2D.target_desired_distance = 8.0

func _physics_process(_delta):
	if active:		
		var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()
		var direction: Vector2 = (next_path_position - global_position).normalized()
		var angle = direction.angle()
		
		if angle < Vector2(0, 1).angle() and angle > Vector2(0, -1).angle():
			$AnimatedSprite2D.scale = Vector2(1, 1)
		else:
			$AnimatedSprite2D.scale = Vector2(-1, 1)
		velocity = direction * speed
		$NavigationAgent2D.set_velocity(velocity)
		move_and_slide()


func _on_notice_area_body_entered(body):
	$Sprite2D.hide()
	$AnimatedSprite2D.show()
	$AnimatedSprite2D.play("show")
	target = body


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation == "show":
		$AnimatedSprite2D.play("move")
		$Timers/NavigationTimer.start()
		$NavigationAgent2D.target_position = target.global_position
		active = true
	elif $AnimatedSprite2D.animation == "explosion_prepare":
		$AnimatedSprite2D.play("explosion")
	elif $AnimatedSprite2D.animation == "explosion":	
		queue_free()


func _on_navigation_timer_timeout():
	$NavigationAgent2D.target_position = target.global_position


func _on_explosion_area_body_entered(body):
	active = false
	$AnimatedSprite2D.play("explosion_prepare")
	$Timers/NavigationTimer.stop()


func _on_animated_sprite_2d_animation_changed():
	if $AnimatedSprite2D.animation == "explosion":
		$AnimatedSprite2D.scale = Vector2(2, 2)
		for entity in get_tree().get_nodes_in_group("Units") + get_tree().get_nodes_in_group("Goblins"):
			if entity.global_position.distance_to(global_position) <= explosion_range:
				entity.hit(damage)
