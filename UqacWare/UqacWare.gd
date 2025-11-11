extends Node

enum Difficulty {
	EASY, NORMAL, HARD
}

enum MiniGameEndState {
	WIN, LOSS, ERROR
}

enum GameMode {
	INFINITE, ALL_GAMES
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _addGame(path : String, boss : bool) -> void:
	var main_scene = get_tree().current_scene
	main_scene.call("addGame", path, boss)

func miniGameEnded(end_state :  MiniGameEndState) -> void:
	var main_scene = get_tree().current_scene
	main_scene.call("_miniGameEnded", end_state)

func initializeGameTimeout(seconds : int) -> void:
	var main_scene = get_tree().current_scene
	main_scene.call("_initializeMiniGameTimeout", seconds)
	pass
