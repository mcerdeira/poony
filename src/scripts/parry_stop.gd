extends Sprite
var stop = 0

func _process(delta):
	if stop > 0:
		stop -= 1 * delta
		if stop <= 0:
			execute_event("up_pause")

func execute_event(event):
	if event == "pause":
		stop = 0.3
		get_tree().paused = true
		show()
	elif event == "up_pause":
		stop = 0
		get_tree().paused = false
		hide()
