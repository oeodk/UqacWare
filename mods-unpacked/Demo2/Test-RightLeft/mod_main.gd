extends Node

var _mod_dir := ""
var _mod_dir_path := ""

# Modifier à true si le niveau est un boss
var boss_game : bool = false

func _init() -> void:
	pass
	# Get the unpacked path of this mod

func register_scene(mod_dir : String) -> void:
	_mod_dir = mod_dir

	_mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(mod_dir)
	var scene_path = _mod_dir_path.path_join("GameFIles/main_scene.tscn")
	UqacWareAPI._addGame(scene_path, boss_game)
