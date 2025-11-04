extends CanvasLayer

signal quit
signal start_game

var _edition_selected : String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	start_game.emit()
	pass # Replace with function body.


func _on_quit_pressed() -> void:
	quit.emit()
	pass # Replace with function body.


func _on_edition_selection_item_selected(index: int) -> void:
	_edition_selected = $EditionSelection.get_item_text(index)
	pass # Replace with function body.

func _initEditionLabel(values : Array) -> void:
	$EditionSelection.add_item("")
	for element in values:
		$EditionSelection.add_item(element)
	pass

func showMenu() -> void:
	$Start.grab_focus()
	show()
