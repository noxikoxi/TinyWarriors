extends CharacterBody2D

class_name NavigableEntity

signal spawnSkull(position: Vector2)

@export var speed:int
var health:int
var damage:int
var immune:bool = false

var active:bool = true
var can_attack:bool = true
var enemy: PhysicsBody2D
var enemy_in_attack_area:bool = false
var enemy_attack_angle: float
var can_change_enemy:bool = true
var target_base:StaticBody2D

var enemy_group:String
var enemy_buildings_group:String
var notice_distance:int = 400

var navigation_calculated_buildings:bool = false

func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)
	

func isEnemyValid(): # Target always exists because of goblin house/castle
	if not is_instance_valid(enemy): # Target was destroyed
		get_next_target(null)
		active = true
		enemy_in_attack_area = false

func _physics_process(_delta):
	isEnemyValid()
	if not is_instance_valid(target_base):
		active = false
		enemy = null
		
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
	elif enemy: # Just attacking, not moving
		var direction: Vector2 = (enemy.global_position - global_position).normalized()
		var angle = direction.angle()
		if angle > 3*PI/4 and angle < 5*PI/4:
			$AnimatedSprite2D.scale = Vector2(-1, 1)
		elif angle > -PI/4 and angle < PI/4:
			$AnimatedSprite2D.scale = Vector2(1, 1)
		
	
func _ready():
	set_physics_process(false)
	call_deferred("actor_setup")
	$NavigationAgent2D.path_desired_distance = 10.0
	$NavigationAgent2D.target_desired_distance = 20.0
	
func shader_on():
	pass
	
func shader_off():
	pass
	
func hit(dmg):
	if !immune:
		health -= dmg
		immune = true
		$Timers/ImmuneTimer.start()
		shader_on()
		if health <= 0:
			spawnSkull.emit(global_position)
			queue_free()
		
		
func _on_navigation_timer_timeout():
	if active and enemy:
		if enemy in get_tree().get_nodes_in_group("Buildings"):
			if not navigation_calculated_buildings:
				$NavigationAgent2D.target_position = enemy.global_position * Vector2(randf_range(0.95, 1.05), 1)
				navigation_calculated_buildings = true
		else:
			$NavigationAgent2D.target_position = enemy.global_position
			navigation_calculated_buildings = false

func get_next_target(actual_target):
	var found_target:bool = false
	for entity in (get_tree().get_nodes_in_group(enemy_group) + get_tree().get_nodes_in_group(enemy_buildings_group)):
		if entity.global_position.distance_to(global_position) <= notice_distance:
			if actual_target!=null and entity == actual_target:
				continue
			enemy = entity
			found_target = true
			if entity in get_tree().get_nodes_in_group(enemy_buildings_group):
				can_change_enemy = true
			else:
				can_change_enemy = false
			break
			
	if not found_target:
		enemy = target_base

func _on_change_target_timeout():
	if can_change_enemy: # First so can change enemy from building to units
		get_next_target(null)


func _on_immune_timer_timeout():
	immune = false
	shader_off()
