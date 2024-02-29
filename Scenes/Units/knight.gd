extends CharacterBody2D

@export var speed:int = 150
@export var hp:int = 30
const damage:int = 10

@export var active:bool = true
var can_attack:bool = true
var enemy: CharacterBody2D
var enemy_in_attack_area:bool = false
var enemy_attack_angle
var can_change_enemy:bool = true

func _physics_process(_delta):
	if $NavigationAgent2D.is_navigation_finished():
		velocity = Vector2(0, 0)
		return
			
	var next_path_position: Vector2 = $NavigationAgent2D.get_next_path_position()
	var direction: Vector2 = (next_path_position - global_position).normalized()
	var angle = direction.angle()
	if angle > 3*PI/4 and angle < 5*PI/4:
		$AnimatedSprite2D.scale = Vector2(-1, 1)
	elif angle > -PI/4 and angle < PI/4:
		$AnimatedSprite2D.scale = Vector2(1, 1)
	velocity = direction * speed
	$NavigationAgent2D.set_velocity(velocity)
	
func _ready():
	$NavigationAgent2D.path_desired_distance = 50.0
	$NavigationAgent2D.target_desired_distance = 50.0
	$NavigationAgent2D.target_position = Globals.goblin_house_position
	$AnimatedSprite2D.play("move")

func _on_navigation_agent_2d_velocity_computed(_safe_velocity):
	pass
	#move_and_slide()


func _on_notice_area_body_entered(body):
	if can_change_enemy and body in get_tree().get_nodes_in_group("Enemies"):
		enemy = body
		can_change_enemy = false
		$NavigationAgent2D.target_position = body.global_position


func _on_notice_area_body_exited(body):
	if  body in get_tree().get_nodes_in_group("Enemies"):
		$NavigationAgent2D.target_position = Globals.goblin_house_position
		$AnimatedSprite2D.play("move")


func _on_attack_area_body_entered(body):
	if body == enemy:
		velocity = Vector2.ZERO
		enemy_in_attack_area = true
		attack()
		

func attack():
	var attack_num:int = randi_range(1, 2)
	var attack_dir: String
	can_attack = false
	enemy_attack_angle = (enemy.global_position - global_position).normalized().angle()
	print(enemy_attack_angle)
		
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
	if enemy_in_attack_area:
		attack()
		

func _on_animated_sprite_2d_animation_finished():
	if $AnimatedSprite2D.animation != "move": # Attack
		$AnimatedSprite2D.play("idle")
		if enemy_in_attack_area:
			enemy.hit(damage)
		


func _on_attack_area_body_exited(body):
	if body == enemy:
		enemy_in_attack_area = false
		can_change_enemy = true
		enemy = null
