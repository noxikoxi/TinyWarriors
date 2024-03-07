extends NavigableEntity

func _ready():
	super._ready()
	speed = 100
	damage = 6
	health = 20
	target_base = Globals.gold_mine_position
	$NavigationAgent2D.target_position = target_base
	$AnimatedSprite2D.play("move")
