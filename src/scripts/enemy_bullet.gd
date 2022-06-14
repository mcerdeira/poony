extends Area2D
var speed = 300
var objettype = "enemybullet"

func initialize(rot):
	rotation_degrees = rot

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	position += transform.x * speed * delta

func _on_visibilitynot_screen_exited():
	queue_free()


func _on_enemy_bullet_area_entered(area):
	if area.objettype == "player":
		if area.parry_ttl <= 0:
			area.hit()
		queue_free()
