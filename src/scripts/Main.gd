extends Node2D

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	if event.is_action_pressed("quit_game"):
		get_tree().quit()
		Global.initialize()
	if event.is_action_pressed("restart_game"):
		Global.initialize()
		get_tree().reload_current_scene()
