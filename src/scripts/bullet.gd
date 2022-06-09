extends Area2D
export var speed : = 300.0
var objettype = "gun"

func _ready():
	pass
	
func init_normal(face_dir, type):
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
	position += transform.x * speed * delta

func _on_bullet_area_entered(area):
	if area.objettype == "enemy":
		area.queue_free()
		queue_free()
