extends Area2D
export var _speed = 120
var face_dir = "R"
var objettype = "player"
var shoot_cooldown = 0
var total_shoot_cooldown = 0.3
#types: pony, unicorn, pegasus
var type = "pony"
var bullet = preload("res://scenes/bullet.tscn")
var screensize = OS.window_size
var player_number = 0

func initialize(_type, _player_number):
	position = Vector2(screensize.x / 2, (screensize.y / 2) + (20 * (_player_number - 1)))
	player_number = _player_number
	type = _type	
	$sprite.animation = type + "_walking"
	
func shoot():
	var w = bullet.instance()
	get_parent().add_child(w)
	w.set_position(position)
	w.init_normal(face_dir, type)
	
func _physics_process(delta):	
	var moving = false
	shoot_cooldown -= 1 * delta
	if shoot_cooldown <= 0:
		shoot()
		shoot_cooldown = total_shoot_cooldown
	
	if Input.is_action_pressed("down" + str(player_number)):
		position.y += _speed * delta
		moving = true
		
	elif Input.is_action_pressed("up" + str(player_number)):
		position.y -= _speed * delta
		moving = true
		
	elif Input.is_action_pressed("left" + str(player_number)):
		$sprite.scale.x = -1
		face_dir = "L"
		position.x -= _speed * delta
		moving = true
		
	elif Input.is_action_pressed("right" + str(player_number)):
		$sprite.scale.x = 1
		face_dir = "R"
		position.x += _speed * delta
		moving = true
		
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	#z_index = -position.y
