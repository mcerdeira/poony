extends Area2D
export var _speed = 120
var face_dir = "R"
var objettype = "player"
var shoot_cooldown = 0
var total_shoot_cooldown = 1
var type = "pony"

func _ready():
	$sprite.animation = type + "_walking"
	
func shoot():
	pass
	
func _physics_process(delta):	
	var moving = false
	shoot_cooldown -= 1 * delta
	if shoot_cooldown <= 0:
		shoot()
		shoot_cooldown = total_shoot_cooldown
	
	if Input.is_action_pressed("down"):
		face_dir = "D"
		position.y += _speed * delta
		moving = true
		
	elif Input.is_action_pressed("up"):
		face_dir = "U"
		position.y -= _speed * delta
		moving = true
		
	elif Input.is_action_pressed("left"):
		$sprite.scale.x = -1
		face_dir = "L"
		position.x -= _speed * delta
		moving = true
		
	elif Input.is_action_pressed("right"):
		$sprite.scale.x = 1
		face_dir = "R"
		position.x += _speed * delta
		moving = true
