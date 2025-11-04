extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Right"):
		gameEnded(true)
	if Input.is_action_pressed("Left"):
		gameEnded(false)
	pass

# Fonction appelé par le jeu principal
# difficulty : la difficulté atuel du jeu
# Entrées possible : 
#	UqacWareAPI.Difficulty.EASY
#	UqacWareAPI.Difficulty.NORMAL
#	UqacWareAPI.Difficulty.HARD
func startGame(difficulty : UqacWareAPI.Difficulty) -> void:
	pass
	
func gameEnded(result : bool) -> void:
	get_parent().miniGameEnded(result);
	pass
