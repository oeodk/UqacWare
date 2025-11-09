extends CanvasLayer

signal return_to_main_menu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_pressed() -> void:
	return_to_main_menu.emit()
	pass # Replace with function body.

func showMenu() -> void:
	$Button.grab_focus()
	show()
	
func setScore(score : int) -> void:
	$Score.text = "Score : " + str(score)
