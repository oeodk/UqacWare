extends CanvasLayer

signal transition_ended

const COUNT_MAX : int = 3
var _countdown : int = COUNT_MAX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _startTransition() -> void:
	show()
	$TimerLabel.text = str(_countdown)
	$Timer.start()
	pass

func _on_timer_timeout() -> void:
	_countdown = _countdown - 1;
	if _countdown > 0:
		$TimerLabel.text = str(_countdown)
	else:
		$TimerLabel.text = "Start"
	if _countdown < 0:
		$Timer.stop()
		_countdown = COUNT_MAX
		transition_ended.emit()
		$SpeedLabel.text = ""
		hide()
	pass # Replace with function body.

func _updateLife(life : int) -> void:
	$LifeLabel.text = "Life : " + str(life)
	
func _updateScore(score : int) -> void:
	$Score.text = "Score : " + str(score)

func _faster() -> void:
	$SpeedLabel.text = "Faster"
