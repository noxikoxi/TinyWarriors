extends NavigableEntity

func _ready():
	super._ready()
	speed = 100
	damage = 6
	health = 20
	target_base = Globals.gold_mine
	enemy = target_base
	$AnimatedSprite2D.play("move")
	
func _on_notice_area_body_entered(body):
	if can_change_enemy: 
		enemy = body
		can_change_enemy = false
		$NavigationAgent2D.target_position = body.global_position
		

func _on_notice_area_body_exited(body):
	if body in get_tree().get_nodes_in_group("Enemies"):
		if not enemy_in_attack_area:
			enemy = null
		$NavigationAgent2D.target_position = target_base
		$AnimatedSprite2D.play("move")

func _on_attack_area_body_entered(body):
	if body == enemy:
		active = false
		enemy_in_attack_area = true
		attack()
		
func _on_attack_area_body_exited(body):
	if body == enemy:
		enemy_in_attack_area = false
		can_change_enemy = true
		enemy = null
		if body in get_tree().get_nodes_in_group("Enemies"):
			active = true
			
func attack():
	can_attack = false
			
	$AnimatedSprite2D.play("axe")
	$Timers/AttackCooldown.start()
	
func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "move": # Attack
		$AnimatedSprite2D.play("idle")
		if enemy_in_attack_area:
			enemy.hit(damage)


func _on_attack_cooldown_timeout():
	can_attack = true
	if enemy_in_attack_area:
		attack()
