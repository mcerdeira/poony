extends Area2D
export var speed : = 600
var objettype = "gun"
var ttl = 0.2
var is_super = false

func _ready():
	pass
	
func init_normal(face_dir, type, super = false):
	is_super = super
	if super:
		ttl = 0.5
		scale *= 2
	
	$sprite.animation = type + "_bullet"
	if face_dir == "L":
		rotation_degrees = 180
	if face_dir == "R": 
		rotation_degrees = 0
	if face_dir == "U":
		rotation_degrees = 270
	if face_dir == "D":
		rotation_degrees = 90

func _physics_process(delta):
	ttl -= 1 * delta
	position += transform.x * speed * delta
	if ttl <= 0:
		queue_free()

func _on_bullet_area_entered(area):
	if area.objettype == "enemy":
		area.hit(is_super)
		queue_free()

func _on_visibilitynot_screen_exited():
	queue_free()
