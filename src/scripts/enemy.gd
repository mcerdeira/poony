extends Area2D
export var total_cooldown = 1.0
export var style = "normal"
var bullet = preload("res://scenes/enemy_bullet.tscn")
var cooldown = total_cooldown
var direction = 180
var objettype = "enemy"

func shoot(delta):
	if style == "mr_T":
		var deg = [0, 90, 180, 270]
		for i in range(deg.size()):
			direction = deg[i]
			var w = bullet.instance()
			get_parent().add_child(w)
			var pos = get_node("bullet_spawn_" + style).position
			w.set_position(to_global(pos))
			w.initialize(direction)			
		
	else:
		var w = bullet.instance()
		get_parent().add_child(w)
		var pos = get_node("bullet_spawn_" + style).position
		w.set_position(to_global(pos))
		w.initialize(direction)
		if style == "rotator":
			direction += 500 * delta
	
func _ready():
	pass # Replace with function body.

func _process(delta):
	$sprite.animation = style
	cooldown -= 1 * delta
	if cooldown <= 0:
		cooldown = total_cooldown
		shoot(delta)
