extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Fonction appelée par le jeu principal
# difficulty : la difficulté atuelle du jeu
# Entrées possible : 
#	UqacWareAPI.Difficulty.EASY
#	UqacWareAPI.Difficulty.NORMAL
#	UqacWareAPI.Difficulty.HARD
func startGame(difficulty : UqacWareAPI.Difficulty) -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
		
# Fonction à appeler quand votre mini jeu est terminé
# Entrées possible : 
#	UqacWareAPI.MiniGameEndState.WIN
#	UqacWareAPI.MiniGameEndState.LOSS
func gameEnded(end_state : UqacWareAPI.MiniGameEndState) -> void:
	UqacWareAPI.miniGameEnded(end_state)
	pass

# Fonction à appeler lors de l'initialisation du jeu
# seconds : le temps maximun du mini jeu
# (Utilité : synchroniser de décompte de l'ui et fermer le jeu si "gameEnded" n'est
# pas appeler avant avant le temps fournis (+1s), ex : bug, softlock, ...)
func initializeGameTimeout(seconds : int) -> void:
	UqacWareAPI.initializeGameTimeout(seconds)
	pass
