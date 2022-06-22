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
var parry_ttl = 0
var parry_failed = false
var parry_cooldown = 0
var horse_of_fire = false
var horse_of_fire_line_MIN = 0.100
var horse_of_fire_line_MAX = 2.353
var horse_of_fire_ttl = horse_of_fire_line_MIN
var horse_of_fire_line = horse_of_fire_line_MAX
var horse_of_fire_line_dir = -1

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
var hit_ttl = 0
var life = 50

func hit():
	if hit_ttl <= 0 and !transformed and !horse_of_fire:
		life -= 1
		hit_ttl = 1
		if life <= 0:
			pass

func initialize(_type, _player_number, _player_name):	
	add_to_group("players")
	
	var sc = get_viewport_rect().size
	position = Vector2(sc.x / 2, (sc.y / 2) + (20 * (_player_number - 1)))
	player_number = _player_number
	player_name = _player_name
	type = _type	
	$sprite.animation = type + "_walking"
	$name_label.text = player_name
	
func transform(what):
	if what == "super_chomp":
		$shadow.position.y += 20
		$collider.disabled = true
		$collider_chomp.disabled = false
		
	hit_ttl = 0
	$sprite.animation = what
	$sprite.speed_scale = 3
	extra_speed = 200
	transformed_what = what
	transformed = true
	transformed_ttl = total_transformed_ttl
	
func get_coin(n):
	if transformed_ttl:
		if transformed_what == "super_chomp":
			var sc = rand_range(0, 3)
			if sc == 0:
				transformed_ttl += n
	else:
		coins += n
	
func shoot():
	if !transformed and !super_shoot:
		var w = bullet.instance()
		get_parent().add_child(w)
		var pos = get_node("pos_" + type).position
		w.set_position(to_global(pos))
		w.init_normal(face_dir, type)
	
func supershoot():
	if !transformed:
		$sprite.material.set_shader_param("applyrainbow", true)
		var w = bullet.instance()
		get_parent().add_child(w)
		var pos = get_node("pos_" + type).position
		w.set_position(to_global(pos))
		w.init_normal(face_dir, type, true)
	
func _physics_process(delta):
	var moving = false
	if hit_ttl > 0:
		hit_ttl -= 1 * delta
		if !super_shoot:
			$sprite.material.set_shader_param("white", true)
		if hit_ttl <= 0:
			$sprite.material.set_shader_param("white", false)
	
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
			if transformed_what == "super_chomp":
				$collider.disabled = false
				$collider_chomp.disabled = true
				$shadow.position.y -= 20
				extra_speed = 0
				
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
			$sprite.material.set_shader_param("applyrainbow", false)
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
		
	if horse_of_fire:
		horse_of_fire_ttl -= 1 * delta
		$sprite.material.set_shader_param("line_scale", horse_of_fire_line)
		horse_of_fire_line += 10 * horse_of_fire_line_dir * delta
		if horse_of_fire_line <= horse_of_fire_line_MIN and horse_of_fire_line_dir == -1:
			horse_of_fire_line_dir = 1
		elif horse_of_fire_line > horse_of_fire_line_MAX and horse_of_fire_line_dir == 1:
			horse_of_fire_line_dir = -1
		
		if horse_of_fire_ttl <= 0:
			Engine.time_scale = 1
			extra_speed = 0
			$sprite.material.set_shader_param("dooutline", false)
			horse_of_fire_line_dir = -1
			horse_of_fire_line = 2.353
			horse_of_fire_ttl = 0
			horse_of_fire = false
			
	if parry_cooldown > 0:
		parry_cooldown -= 1 * delta
		
	if !horse_of_fire and !transformed and parry_ttl <= 0 and hit_ttl <= 0:
		if parry_cooldown <= 0 and Input.is_action_just_pressed("parry" + str(player_number)):
			parry_cooldown = 1
			parry_ttl = 0.25
			parry_failed = false
			
	if parry_ttl > 0:
		parry_ttl -= 1 * delta
		$sprite.rotation_degrees -= 1000 * delta
		if parry_ttl <= 0:
			parry_failed = false
			$sprite.rotation_degrees = 0
			parry_ttl = 0
	
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

func success_parry():
	$sprite.material.set_shader_param("dooutline", true)
	horse_of_fire = true
	horse_of_fire_ttl = 15
	extra_speed = 150
	
func parryOK(pos):
	if position.distance_to(pos) <= 20 and parry_ttl > 0:
		get_parent().get_node("parry_stop").execute_event("pause")
		Engine.time_scale = 0.5
		return true
	else:
		parry_failed = true
		return false

func _on_player_area_entered(area):
	if area.objettype == "enemybullet":
		if parryOK(area.position):
			if !parry_failed:
				area.queue_free()
				success_parry()
		
	elif area.objettype == "enemy":
		if transformed:
			area.queue_free()
		else:
			if parryOK(area.position):
				if !parry_failed:
					success_parry()
			else:
				hit()
