extends Node

var _mini_game_scenes: Array = []
var _available_games: Dictionary = {}
var _current_mod_folder : String = ""

var _current_mini_game_instance : Node = null
var _current_mini_game : PackedScene # Returns a PackedScene

var _mod_folder : String = ""

var _edition : Array = []

var _life : int = 3
var _current_difficulty : UqacWareAPI.Difficulty = UqacWareAPI.Difficulty.EASY
var _game_won : int = 0

const _normal_difficulty_threshold : int = 10
const _hard_difficulty_threshold : int = 20
const _win_threshold : int = 30

func _init() -> void:
	pass
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_edition = getFolderInUnpackedMod()
	$MainMenu._initEditionLabel(_edition)
	$MainMenu.showMenu()
	$WinScreen.hide()
	$GameOverSceeen.hide()
	$TransitionScreen.hide()
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


func _on_main_menu_quit() -> void:
	quit()
	pass # Replace with function body.


func _on_main_menu_start_game() -> void:
	startGame()
	pass # Replace with function body.

func loadGames(mods_dir : String) ->void:
	_current_mod_folder = mods_dir
	if not _available_games.has(_current_mod_folder):
		_available_games[_current_mod_folder] = []
		var mods_path = "res://mods-unpacked/" + mods_dir
		ModLoaderStore.unpacked_dir = mods_path
		ModLoader.load_mods()
	pass

func _initAvailableGame(edition : String) ->void:
	_mini_game_scenes.clear()
	if edition == "":
		for selected_edition in _available_games:
			_mini_game_scenes.append_array(_available_games[selected_edition])
	else:
		_mini_game_scenes.append_array(_available_games[edition])

	pass

func addGame(scene_path : String) -> void:
	_available_games[_current_mod_folder].append(scene_path)
	pass
 
func miniGameEnded(result : bool) -> void:
	if result :
		_game_won = _game_won + 1
		$TransitionScreen._updateScore(_game_won)
	else:
		_life = _life - 1
		$TransitionScreen._updateLife(_life)
		
	if _life == 0:
		resetCurrentGame()
		gameOver()
		return
		
	if _game_won >= _win_threshold:
		resetCurrentGame()
		win()
		return
	
	if _current_difficulty == UqacWareAPI.Difficulty.EASY and _game_won >= _normal_difficulty_threshold:
		_current_difficulty = UqacWareAPI.Difficulty.NORMAL
		$TransitionScreen._faster()
		
	if _current_difficulty == UqacWareAPI.Difficulty.NORMAL and _game_won >= _hard_difficulty_threshold:
		_current_difficulty = UqacWareAPI.Difficulty.HARD
		$TransitionScreen._faster()
		
	_startTransition()
	pass

func resetCurrentGame()->void:
	if _current_mini_game_instance != null:
		_current_mini_game_instance.queue_free()
		remove_child(_current_mini_game_instance)
		_current_mini_game_instance = null

func startRandomGame() -> void:
	
	var random_index = randi() % _mini_game_scenes.size()
	_current_mini_game = load(_mini_game_scenes[random_index]) 
	_current_mini_game_instance = _current_mini_game.instantiate()
	add_child(_current_mini_game_instance)
	_current_mini_game_instance.set_process(true)
	_current_mini_game_instance.startGame(_current_difficulty)
	pass

func win() -> void:
	$WinScreen.showMenu()
	pass

func gameOver() -> void:
	$GameOverSceeen.showMenu()
	pass

func _startTransition()->void:
	resetCurrentGame()
	$TransitionScreen._startTransition()
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


func _on_game_over_sceeen_return_to_main_menu() -> void:
	_resetGame()
	pass # Replace with function body.


func _on_win_screen_return_to_main_menu() -> void:
	_resetGame()
	pass # Replace with function body.

func _resetGame() ->void:
	$WinScreen.hide()
	$GameOverSceeen.hide()
	$MainMenu.showMenu()
	_life = 3
	_current_difficulty = UqacWareAPI.Difficulty.EASY
	_game_won = 0
	
	pass


func _on_transition_screen_transition_ended() -> void:
	startRandomGame()
	pass # Replace with function body.
