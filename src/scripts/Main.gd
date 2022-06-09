extends Node2D

var player = preload("res://scenes/player.tscn")
var players_obj = preload("res://scripts/players.gd")

func _ready():
	var players = []
	
	var g = players_obj.new()
	g.player_number = 1
	g.type = "pony"
	players.append(g);
	
	g = players_obj.new()
	g.player_number = 2
	g.type = "pegasus"
	players.append(g);
	
	for i in range(players.size()):
		var w = player.instance()
		add_child(w)
		w.initialize(players[i].type, players[i].player_number)

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
		Global.initialize()
	if event.is_action_pressed("restart_game"):
		Global.initialize()
		get_tree().reload_current_scene()
