extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("Up"):
		gameEnded(UqacWareAPI.MiniGameEndState.WIN)
	if Input.is_action_pressed("Down"):
		gameEnded(UqacWareAPI.MiniGameEndState.LOSS)
	pass

# Fonction appelé par le jeu principal
# difficulty : la difficulté atuel du jeu
# Entrées possible : 
#	UqacWareAPI.Difficulty.EASY
#	UqacWareAPI.Difficulty.NORMAL
#	UqacWareAPI.Difficulty.HARD
func startGame(difficulty : int) -> void:
	var time : int = max(1,4-difficulty)
	initializeGameTimeout(time)
	$Timer.wait_time = time
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
