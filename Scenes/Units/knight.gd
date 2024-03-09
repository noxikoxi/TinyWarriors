extends NavigableEntity

func _ready():
	super._ready()
	speed = 180
	damage = 10
	health = 30
	target_base = Globals.goblin_house
	enemy = target_base
	enemy_group = "Goblins"
	enemy_buildings_group = "GoblinBuildings"
	$AnimatedSprite2D.play("move")


func shader_on():
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0.8)
	
func shader_off():
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)

func _process(_delta):
	if active:
		isEnemyValid()
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

func _on_attack_cooldown_timeout():
	can_attack = true
	if enemy and enemy_in_attack_area:
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
			
