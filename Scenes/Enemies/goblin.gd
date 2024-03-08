extends NavigableEntity

func _ready():
	super._ready()
	speed = 150
	damage = 10
	health = 20
	target_base = Globals.castle
	enemy_group = "Units"
	enemy_buildings_group = "Buildings"
	enemy = target_base
	$AnimatedSprite2D.play("move")
	
	
func _process(_delta):
	if active:
		if $AttackArea.overlaps_body(enemy):
			active = false
			enemy_in_attack_area = true
			if can_attack:
				attack()
		else:
			enemy_in_attack_area = false
			active = true
			$AnimatedSprite2D.play("move")

		
func attack():
	var attack_dir: String
	can_attack = false
	enemy_attack_angle = (enemy.global_position - global_position).normalized().angle()
		
	if enemy_attack_angle >= PI/4 and enemy_attack_angle <= 3*PI/4:
		attack_dir = "down"
	elif enemy_attack_angle <= -PI/4 and enemy_attack_angle >= -3*PI/4:
		attack_dir = "top"
	else:
		attack_dir = "right"
			
	$AnimatedSprite2D.play("attack_" + attack_dir)
	$Timers/AttackTimer.start()


func _on_attack_timer_timeout():
	can_attack = true
	if enemy_in_attack_area:
		attack()


func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "move": # Attack
		$AnimatedSprite2D.play("idle")
		if enemy_in_attack_area:
			var temp_enemy = enemy
			if enemy.health - damage <= 0:
				enemy_in_attack_area = false
				if enemy == target_base:
					active = false
					enemy = null
				else:
					active = true
					get_next_target(enemy)
				
			temp_enemy.hit(damage)
