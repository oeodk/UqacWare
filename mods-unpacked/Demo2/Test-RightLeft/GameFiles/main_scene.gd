extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Right"):
		gameEnded(UqacWareAPI.MiniGameEndState.WIN)
	if Input.is_action_pressed("Left"):
		gameEnded(UqacWareAPI.MiniGameEndState.LOSS)
	pass

# Fonction appelé par le jeu principal
# difficulty : la difficulté atuel du jeu
# Entrées possible : 
#	UqacWareAPI.Difficulty.EASY
#	UqacWareAPI.Difficulty.NORMAL
#	UqacWareAPI.Difficulty.HARD
func startGame(difficulty : UqacWareAPI.Difficulty) -> void:
	match difficulty:
		UqacWareAPI.Difficulty.EASY:
			initializeGameTimeout(5)
			$Timer.wait_time = 3
		UqacWareAPI.Difficulty.NORMAL:
			initializeGameTimeout(4)
			$Timer.wait_time = 2
		UqacWareAPI.Difficulty.HARD:
			initializeGameTimeout(3)
			$Timer.wait_time = 1
	$Timer.start()	
	pass
	
func gameEnded(result : UqacWareAPI.MiniGameEndState) -> void:
	UqacWareAPI.miniGameEnded(result)
	pass

# Fonction à appeler lors de l'initialisation du jeu
# seconds : le temps maximun du mini jeu
# (Utilité : synchroniser de décompte de l'ui et fermer le jeu si "gameEnded" n'est
# pas appeler avant avant le temps fournis (+1s), ex : bug, softlock, ...)
func initializeGameTimeout(seconds : int) -> void:
	UqacWareAPI.initializeGameTimeout(seconds)
	pass


func _on_timer_timeout() -> void:
	gameEnded(UqacWareAPI.MiniGameEndState.LOSS)
	pass # Replace with function body.
