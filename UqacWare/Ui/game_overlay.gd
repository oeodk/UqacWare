extends CanvasLayer

var _time_counter : int = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func showOverlay(game_duration : int) -> void:
	_time_counter = game_duration
	$Label.text = str(_time_counter)
	$Timer.start()
	show()
	pass

func hideOverlay() -> void:
	$Timer.stop()
	hide()

func _on_timer_timeout() -> void:
	_time_counter -= 1 
	if _time_counter < 0:
		$Label.text = "Game error, please wait..."
	else:
		$Label.text = str(_time_counter)
	pass
