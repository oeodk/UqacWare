extends CanvasLayer

signal quit
signal start_game(gamemode : UqacWareAPI.GameMode)

var _edition_selected : String = ""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var popup = $EditionSelection.get_popup()
	var font_size = $EditionSelection.get_theme_font_size("font_size")
	popup.add_theme_font_size_override("font_size", font_size / 2)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	$StartAllGame.grab_focus()
	show()


func _on_start_all_game_pressed() -> void:
	start_game.emit(UqacWareAPI.GameMode.ALL_GAMES)
	pass # Replace with function body.


func _on_start_infinite_pressed() -> void:	
	start_game.emit(UqacWareAPI.GameMode.INFINITE)
	pass # Replace with function body.
