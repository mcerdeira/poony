extends Node
var big_coin = preload("res://scenes/big_coin.tscn")
var coin = preload("res://scenes/coin.tscn")
var coin_cooldown_total = 2
var big_coin_cooldown_total = 300
var coin_cooldown = coin_cooldown_total
var big_coin_cooldown = big_coin_cooldown_total

func _process(delta):
	coin_cooldown -= 1 * delta
	big_coin_cooldown -= 1 * delta
	
	spawn_enemies()
	spawn_big_coins()
	spawn_coins()

func spawn_enemies():
	pass

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
		var coins = 5 + (randi() % 10)
		
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
