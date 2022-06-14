extends Area2D
export var speed : = 200.0
var objettype = "big_coin"
var direction = ""

func initialize(pos, dir, idx, randomX, randomY):
	position = to_global(pos)
	direction = dir
	
	var coin_size = $sprite.frames.get_frame("default", 0).get_size()
	var buf = 10
	
	if direction == "L":
		position.x += (coin_size.x + buf) * idx
	if direction == "R":
		position.x -= (coin_size.x + buf) * idx
	if direction == "U":
		position.y += (coin_size.y + buf) * idx
	if direction == "D":
		position.y -= (coin_size.y + buf) * idx
	
	if direction == "L" or direction == "R":
		position.y = randomY
		
	if direction == "U" or direction == "D":
		position.x = randomX

func get_players():
	return get_tree().get_nodes_in_group("players")

func _physics_process(delta):
	var pl = get_players()
	var magnetic = false
	for p in pl:
		if position.distance_to(p.position) <= 60:
			position = position.move_toward(p.position , delta * (speed * 2))
			magnetic = true
			break
	
	if !magnetic:
		if direction == "L":
			position.x -= speed * delta
		if direction == "R":
			position.x += speed * delta
		if direction == "U":
			position.y -= speed * delta
		if direction == "D":
			position.y += speed * delta
		
	z_index = position.y


func _on_coin_area_entered(area):
	if area.objettype == "player":
		area.get_coin(1)
		queue_free()

func _on_visibility_screen_exited():
	if position.x <= -10:
		queue_free()
