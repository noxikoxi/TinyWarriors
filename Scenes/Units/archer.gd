extends NavigableEntity

signal spawnArrow(position, direction)

func _ready():
	super._ready()
	speed = 150
	damage = 8
	health = 18
	notice_distance = 700
	
	target_base = Globals.goblin_house
	enemy = target_base
	enemy_group = "Goblins"
	enemy_buildings_group = "GoblinBuildings"
	$AnimatedSprite2D.play("move")
	
func attack():
	$AnimatedSprite2D.play('attack_right')
	$Timers/AttackCooldown.start()
		
		
	
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
	
func _on_animated_sprite_2d_animation_finished():
	var direction = (enemy.global_position - $ArrowSpawnPoint.global_position).normalized()
	spawnArrow.emit($ArrowSpawnPoint.global_position, direction)
	$AnimatedSprite2D.play('idle')
	
func _on_attack_cooldown_timeout():
	can_attack = true
	if enemy and enemy_in_attack_area:
		attack()
