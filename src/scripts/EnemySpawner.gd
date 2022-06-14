extends Node
var enemy = preload("res://scenes/enemy.tscn")
var big_coin = preload("res://scenes/big_coin.tscn")
var coin = preload("res://scenes/coin.tscn")
var coin_cooldown_total = 3
var big_coin_cooldown_total = 300
var coin_cooldown = coin_cooldown_total
var big_coin_cooldown = big_coin_cooldown_total
var enemy_cooldown_total = 5
var enemy_cooldown = 0
var enemy_styles = ["normal", "mr_T", "rotator"]

func _process(delta):
	coin_cooldown -= 1 * delta
	big_coin_cooldown -= 1 * delta
	enemy_cooldown -= 1 * delta
	
	spawn_enemies()
	spawn_big_coins()
	spawn_coins()
	
func get_count_in_group(style):
	return get_tree().get_nodes_in_group(style + "_group").size()

func spawn_enemies():
	if enemy_cooldown <= 0:
		enemy_cooldown = enemy_cooldown_total
		var options = [1,2,3,4,5,6,7,8]
		var boost = [0, 150, 100, 0]
		var style:int = randi() % enemy_styles.size()
		
		if enemy_styles[style] == "mr_T" and get_count_in_group("mr_T") > 0:
			enemy_cooldown = 0 #fuerzo reentrada, ponele
			return
		
		if enemy_styles[style] == "mr_T":
			for i in range(1, 4):
				var rand_index:int = randi() % options.size()
				var o = options[rand_index]
				var obj = get_parent().get_node("enemy_pos" + str(o))
				var w = enemy.instance()
				get_parent().add_child(w)
				var node_dest = get_parent().get_node("rotator_patA" + str(i))
				w.initialize(obj.position, enemy_styles[style], node_dest, boost[i])
		else:
			var rand_index:int = randi() % options.size()
			var o = options[rand_index]
			var obj = get_parent().get_node("enemy_pos" + str(o))
			var w = enemy.instance()
			get_parent().add_child(w)
			w.initialize(obj.position, enemy_styles[style])

func spawn_big_coins():
	if big_coin_cooldown <= 0:
		big_coin_cooldown = big_coin_cooldown_total
		var options = [1,2,3,4]
		var rand_index:int = randi() % options.size()
		var o = options[rand_index]
		var obj = get_parent().get_node("big_coin_pos" + str(o))
		var w = big_coin.instance()
		get_parent().add_child(w)
		w.initialize(obj.position)

func spawn_coins():
	if coin_cooldown <= 0:
		coin_cooldown = coin_cooldown_total
		var coins = 3 + (randi() % 5)
		
		var options = ["L","R","U","D"]
		var rand_index:int = randi() % options.size()
		var o = "L"#options[rand_index]
		var obj = get_parent().get_node("coin_" + str(o))
		
		var randomX = rand_range(20, 460)
		var randomY = rand_range(20, 250)
		
		for c in range(coins):
			var w = coin.instance()
			get_parent().add_child(w)
			w.initialize(obj.position, o, c, randomX, randomY)
