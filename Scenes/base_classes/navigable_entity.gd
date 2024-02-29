extends CharacterBody2D

class_name NavigableEntity

@export var speed:int
var health:int
var damage:int

var active:bool = true
var can_attack:bool = true
var enemy: CharacterBody2D
var enemy_in_attack_area:bool = false
var enemy_attack_angle: float
var can_change_enemy:bool = true
var see_enemy:bool = false
var target_base:Vector2

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)

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
	move_and_slide()
	
func _ready():
	set_physics_process(false)
	call_deferred("actor_setup")
	$NavigationAgent2D.path_desired_distance = 20.0
	$NavigationAgent2D.target_desired_distance = 20.0
	
func hit(dmg):
	health -= dmg
	if health <= 0:
		queue_free()
		
func _on_navigation_timer_timeout():
	if see_enemy:
		$NavigationAgent2D.target_position = enemy.global_position
	else:
		$NavigationAgent2D.target_position = target_base
			
