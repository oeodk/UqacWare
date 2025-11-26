extends Node

var _mini_game_scenes: Array = []
var _boss_game_scenes: Array = []

var _available_games: Dictionary = {}
var _available_boss_games : Dictionary = {}
var _current_mod_folder : String = ""

var _current_mini_game_instance : Node = null
var _current_mini_game : PackedScene

var _mod_folder : String = ""

var _edition : Array = []

const _base_life : int = 3
var _life : int = _base_life

var _mini_game_duration : int = 0

var _current_difficulty : int = 1
const DEFAULT_DIFFICULTY_STEP : int = 10
const DIFFICULTY_INCREASE_STEP : int = 1
var _dificulty_step : int = DEFAULT_DIFFICULTY_STEP
var _game_won : int = 0
var _game_cleared_in_current_difficulty : int = 0

var _gamemode : UqacWareAPI.GameMode = UqacWareAPI.GameMode.INFINITE
var _boss_battle : bool = false

func _init() -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_edition = getFolderInUnpackedMod()
	$MainMenu._initEditionLabel(_edition)
	_resetGame()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func startGame() -> void:
	_mod_folder = $MainMenu._edition_selected
	if _mod_folder == "":
		for folder in _edition:
			loadGames(folder)
	else:
		loadGames(_mod_folder)
	_initAvailableGame(_mod_folder)
	$MainMenu.hide()
	_startTransition()
	pass
	
func quit() -> void:
	get_tree().quit()
	pass

func loadGames(mods_dir : String) ->void:
	_current_mod_folder = mods_dir
	if not _available_games.has(_current_mod_folder):
		_available_games[_current_mod_folder] = []
		_available_boss_games[_current_mod_folder] = []
		var mods_path = "res://mods-unpacked/" + mods_dir
		ModLoaderStore.unpacked_dir = mods_path
		ModLoader.load_mods()
	pass

func _initAvailableGame(edition : String) ->void:
	_mini_game_scenes.clear()
	if edition == "":
		for selected_edition in _available_games:
			_mini_game_scenes.append_array(_available_games[selected_edition])
			_boss_game_scenes.append_array(_available_boss_games[selected_edition])
	else:
		_mini_game_scenes.append_array(_available_games[edition])
		_boss_game_scenes.append_array(_available_boss_games[edition])

	match _gamemode:
		UqacWareAPI.GameMode.INFINITE:
			_dificulty_step = DEFAULT_DIFFICULTY_STEP
		UqacWareAPI.GameMode.ALL_GAMES:
			_dificulty_step = _mini_game_scenes.size()  / _boss_game_scenes.size()
	pass

func addGame(scene_path : String, boss : bool) -> void:
	if boss:
		_available_boss_games[_current_mod_folder].append(scene_path)
	else:
		_available_games[_current_mod_folder].append(scene_path)
	pass
 
func _miniGameEnded(end_state : UqacWareAPI.MiniGameEndState) -> void:
	$MiniGameTimer.stop()
	match end_state:
		UqacWareAPI.MiniGameEndState.WIN:
			_game_won = _game_won + 1
			$TransitionScreen._updateScore(_game_won)
		UqacWareAPI.MiniGameEndState.LOSS:
			_life = _life - 1
			$TransitionScreen._updateLife(_life)
	
	if _life <= 0:
		resetCurrentGame()
		gameOver()
		return
	
	if _gamemode == UqacWareAPI.GameMode.ALL_GAMES:
		if _mini_game_scenes.is_empty() && _boss_game_scenes.is_empty():
			resetCurrentGame()
			win()
			return
	
	if _boss_battle:
		_increaseDifficulty()
		_boss_battle = false
	else:
		_game_cleared_in_current_difficulty += 1
		if _game_cleared_in_current_difficulty == _dificulty_step:
			_enableBossBattle()		
	_startTransition()
	pass

func _increaseDifficulty() -> void:
	_current_difficulty += DIFFICULTY_INCREASE_STEP
	_game_cleared_in_current_difficulty = 0
	$TransitionScreen._faster()
	pass

func _enableBossBattle() -> void:
	_boss_battle = true
	if _boss_game_scenes.size() > 0:
		$TransitionScreen.anounceBoss()


func resetCurrentGame()->void:
	if _current_mini_game_instance != null:
		_current_mini_game_instance.queue_free()
		remove_child(_current_mini_game_instance)
		_current_mini_game_instance = null
	$GameOverlay.hideOverlay()

func startRandomGame() -> void:
	
	var random_index : int
	if _boss_battle && _boss_game_scenes.size() > 0 :
		random_index = randi() % _boss_game_scenes.size()
		_current_mini_game = load(_boss_game_scenes[random_index]) 
		if _gamemode == UqacWareAPI.GameMode.ALL_GAMES:
			_boss_game_scenes.erase(_boss_game_scenes[random_index])
	else:
		random_index = randi() % _mini_game_scenes.size()
		_current_mini_game = load(_mini_game_scenes[random_index]) 
		if _gamemode == UqacWareAPI.GameMode.ALL_GAMES:
			_mini_game_scenes.erase(_mini_game_scenes[random_index])
		
	_current_mini_game_instance = _current_mini_game.instantiate()
	add_child(_current_mini_game_instance)
	_current_mini_game_instance.set_process(true)
	_current_mini_game_instance.startGame(_current_difficulty)
	
	$GameOverlay.showOverlay(_mini_game_duration)
	$MiniGameTimer.start()
	pass

func win() -> void:
	$WinScreen.setScore(_game_won)
	$WinScreen.showMenu()
	pass

func gameOver() -> void:
	$GameOverSceeen.setScore(_game_won)
	$GameOverSceeen.showMenu()
	pass

func getFolderInUnpackedMod() -> Array:
	var path : String = ProjectSettings.globalize_path("res://") + "mods-unpacked"
	var folders: Array = []
	var dir := DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				folders.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()    
	return folders

func _resetGame() ->void:
	$WinScreen.hide()
	$GameOverSceeen.hide()
	$MainMenu.showMenu()
	$GameOverlay.hideOverlay()
	$TransitionScreen._updateScore(0)
	$TransitionScreen._updateLife(_base_life)
	_life = _base_life
	_current_difficulty = UqacWareAPI.Difficulty.EASY
	_game_won = 0
	_mini_game_duration = 0
	_game_cleared_in_current_difficulty = 0
	_boss_battle = false
	pass

func _startTransition()->void:
	resetCurrentGame()
	$TransitionScreen._startTransition()
	pass

func _initializeMiniGameTimeout(seconds : int) -> void:
	$MiniGameTimer.wait_time = seconds + 1
	_mini_game_duration = seconds
	pass

func _initOverlay() -> void:
	$SecondsTimer.start()
	pass

func _on_game_over_sceeen_return_to_main_menu() -> void:
	_resetGame()
	pass # Replace with function body.


func _on_win_screen_return_to_main_menu() -> void:
	_resetGame()
	pass # Replace with function body.


func _on_main_menu_quit() -> void:
	quit()
	pass # Replace with function body.

func _on_main_menu_start_game(gamemode : UqacWareAPI.GameMode) -> void:
	_gamemode = gamemode
	startGame()
	pass # Replace with function body.


func _on_transition_screen_transition_ended() -> void:
	startRandomGame()
	pass # Replace with function body.


func _on_mini_game_timer_timeout() -> void:
	_miniGameEnded(UqacWareAPI.MiniGameEndState.ERROR)
	pass # Replace with function body.
