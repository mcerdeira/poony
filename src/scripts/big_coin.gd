extends Area2D
export var speed : = 350.0
var objettype = "big_coin"

func initialize(pos):
	position = to_global(pos)

func _physics_process(delta):
	position.x -= speed * delta
	z_index = position.y

func _on_big_coin_area_entered(area):
	if area.objettype == "player":
		area.transform("boxer")
		queue_free()


func _on_visibility_screen_exited():
	if position.x <= -10:
		queue_free()
