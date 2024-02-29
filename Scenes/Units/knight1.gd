extends NavigableEntity

func _ready():
	super._ready()
	speed = 300
	damage = 10
	health = 30
	target_base = Globals.goblin_house_position
	$NavigationAgent2D.target_position = target_base
	$AnimatedSprite2D.play("move")
	

func _on_attack_area_body_entered(body):
	if body == enemy:
		velocity = Vector2.ZERO
		enemy_in_attack_area = true
		attack()


func _on_attack_area_body_exited(body):
	if body == enemy:
		enemy_in_attack_area = false
		can_change_enemy = true
		enemy = null
		
		
func attack():
	var attack_num:int = randi_range(1, 2)
	var attack_dir: String
	can_attack = false
	enemy_attack_angle = (enemy.global_position - global_position).normalized().angle()
		
	if enemy_attack_angle >= PI/4 and enemy_attack_angle <= 3*PI/4:
		attack_dir = "down"
	elif enemy_attack_angle <= -PI/4 and enemy_attack_angle >= -3*PI/4:
		attack_dir = "top"
	else:
		attack_dir = "right"
			
	$AnimatedSprite2D.play("attack_" + attack_dir + "_" + str(attack_num))
	$Timers/AttackCooldown.start()


func _on_notice_area_body_entered(body):
	if can_change_enemy and body in get_tree().get_nodes_in_group("Enemies"):
		enemy = body
		can_change_enemy = false
		see_enemy = true
		$NavigationAgent2D.target_position = body.global_position


func _on_notice_area_body_exited(body):
	if  body in get_tree().get_nodes_in_group("Enemies"):
		see_enemy = false
		$NavigationAgent2D.target_position = target_base
		$AnimatedSprite2D.play("move")


func _on_attack_cooldown_timeout():
	can_attack = true
	if enemy_in_attack_area:
		attack()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "move": # Attack
		$AnimatedSprite2D.play("idle")
		if enemy_in_attack_area:
			enemy.hit(damage)
