extends Area2D
export var total_cooldown = 1.0
export var style = "normal"
var bullet = preload("res://scenes/enemy_bullet.tscn")
var cooldown = total_cooldown
var direction = 180
var speed = 20
var objettype = "enemy"
var life = 20
var hit_ttl = 0
var shoot_paused = false
var node_dest = null
var shoot_timer = 0
var go_home = false

func initialize(pos, _style, _node_dest = null, _speed_boost = 0):
	node_dest = _node_dest
	position = to_global(pos)
	style = _style
	
	add_to_group(style + "_group")
	if style == "mr_T":
		speed = 100 + _speed_boost
		total_cooldown = 0.1
		position.y = node_dest.position.y
		shoot_paused = true
		shoot_timer = 5
	elif style == "rotator":
		total_cooldown = 0.2

func hit(super):
	hit_ttl = 1
	if super:
		life -= 10
	else:
		life -= 1
	
	if life <= 0:
		queue_free()

func shoot(delta):
	if style == "mr_T":
		if !shoot_paused:
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
			direction += 2000 * delta
	
func _ready():
	pass # Replace with function body.

func _process(delta):
	position.x -= speed * delta
	if !go_home and shoot_paused and style == "mr_T":
		if position.distance_to(node_dest.position) <= 2:
			shoot_paused = false
			speed = 0
	
	if hit_ttl > 0:
		hit_ttl -= 1 * delta
		$sprite.material.set_shader_param("white", true)
		if hit_ttl <= 0:
			$sprite.material.set_shader_param("white", false)
	
	$sprite.animation = style
	cooldown -= 1 * delta
	
	if style == "mr_T" and !shoot_paused:
		shoot_timer -= 1 * delta
		if shoot_timer <= 0:
			shoot_paused = true
			speed = 200
			go_home = true
	
	if cooldown <= 0:
		cooldown = total_cooldown
		shoot(delta)

func _on_visibilitynot_screen_exited():
	if position.x <= -30:
		queue_free()
