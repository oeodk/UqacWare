extends Node

enum Difficulty {
	EASY, NORMAL, HARD
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func addGame(path : String) -> void:
	var main_scene = get_tree().current_scene
	main_scene.call("addGame", path)
