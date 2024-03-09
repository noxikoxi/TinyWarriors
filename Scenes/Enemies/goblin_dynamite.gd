extends NavigableEntity

signal spawnDynamite(position, direction)

func _ready():
	super._ready()
	speed = 120
	health = 16
	notice_distance = 500
	
	target_base = Globals.castle
	enemy = target_base
	enemy_group = "Units"
	enemy_buildings_group = "Buildings"
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
	
func shader_on():
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0.8)
	
func shader_off():
	$AnimatedSprite2D.material.set_shader_parameter("progress", 0)
	
func attack():
	$AnimatedSprite2D.play('attack')
	$Timers/AttackCooldown.start()


func _on_attack_cooldown_timeout():
	can_attack = true
	if enemy and enemy_in_attack_area:
		attack()


func _on_animated_sprite_2d_animation_finished():
	if enemy != null:
		var direction = (enemy.global_position - $DynamiteSpawnPoint.global_position).normalized()
		spawnDynamite.emit($DynamiteSpawnPoint.global_position, direction)
		$AnimatedSprite2D.play('idle')
