extends Area2D
export var _speed = 120
var extra_speed = 0
var face_dir = "R"
var face_num = 1
var objettype = "player"
var super_shoot_cooldown = 0
var total_super_shoot_cooldown = 6
var super_shoot = false
var super_shoot_ttl = 0
var total_super_shoot_ttl = 3
var transformed = false
var transformed_ttl = 0
var total_transformed_ttl = 10
var transformed_what = ""

var shoot_cooldown = 0
var total_shoot_cooldown = 0.1
#types: pony, unicorn, pegasus
var type = "pony"
var bullet = preload("res://scenes/bullet.tscn")
var screensize = OS.window_size
var player_number = 0
var player_name = ""
var coins = 0
var coin_transform = 15

func initialize(_type, _player_number, _player_name):
	var sc = get_viewport_rect().size
	position = Vector2(sc.x / 2, (sc.y / 2) + (20 * (_player_number - 1)))
	player_number = _player_number
	player_name = _player_name
	type = _type	
	$sprite.animation = type + "_walking"
	$name_label.text = player_name
	
func transform(what):
	$sprite.animation = what
	$sprite.speed_scale = 3
	extra_speed = 200
	transformed_what = what
	transformed = true
	transformed_ttl = total_transformed_ttl
	
func shoot():
	if !transformed and !super_shoot:
		var w = bullet.instance()
		get_parent().add_child(w)
		var pos = get_node("pos_" + type).position
		w.set_position(to_global(pos))
		w.init_normal(face_dir, type)
	
func supershoot():
	if !transformed:
		var w = bullet.instance()
		get_parent().add_child(w)
		var pos = get_node("pos_" + type).position
		w.set_position(to_global(pos))
		w.init_normal(face_dir, type, true)
	
func _physics_process(delta):
	var moving = false
	if coins >= coin_transform:
		coins = 0
		transform("super_chomp")
		
	if transformed:
		if transformed_what == "super_chomp":
			var w = bullet.instance()
			get_parent().add_child(w)
			var pos = get_node("pos_chomp").position
			w.set_position(to_global(pos))
			var dir = ""
			if face_dir == "L":
				dir = "R" 
			else:
				dir = "L"	
			w.init_normal(dir, "pony", true)
			
			var sc = rand_range(0, 0.2)
			scale.x = face_num + sc
			scale.y = 1 + sc
			
		transformed_ttl -= 1 * delta
		if transformed_ttl <= 0:
			scale.x = face_num
			scale.y = 1
			$sprite.speed_scale = 1
			$sprite.animation = type + "_walking"
			transformed = false
			transformed_ttl = total_transformed_ttl
		
	if super_shoot:
		supershoot()
		super_shoot_ttl -= 1 * delta
		if super_shoot_ttl <= 0:
			super_shoot = false
			super_shoot_ttl = total_super_shoot_ttl
	
	shoot_cooldown -= 1 * delta
	if shoot_cooldown <= 0:		
		shoot()
		shoot_cooldown = total_shoot_cooldown
		
	super_shoot_cooldown -= 1 * delta
		
	if super_shoot_cooldown <= 0 and Input.is_action_just_pressed("supershoot" + str(player_number)):
		super_shoot_cooldown = total_super_shoot_cooldown
		super_shoot_ttl = total_super_shoot_ttl
		super_shoot = true
	
	if Input.is_action_pressed("down" + str(player_number)):		
		position.y += (_speed + extra_speed) * delta
		moving = true
		
	elif Input.is_action_pressed("up" + str(player_number)):
		position.y -= (_speed + extra_speed) * delta
		moving = true
		
	elif Input.is_action_pressed("left" + str(player_number)):
		scale.x = -1
		$name_label.rect_scale.x = -1
		face_dir = "L"
		face_num = -1
		position.x -= (_speed + extra_speed) * delta
		moving = true
		
	elif Input.is_action_pressed("right" + str(player_number)):
		scale.x = 1
		$name_label.rect_scale.x = 1
		face_dir = "R"
		face_num = 1
		position.x += (_speed + extra_speed) * delta
		moving = true
		
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)

	z_index = position.y
