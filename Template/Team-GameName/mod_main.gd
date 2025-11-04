extends Node

const MOD_DIR := "Team-GameName"

var mod_dir_path := ""

func _init() -> void:
	# Get the unpacked path of this mod
	mod_dir_path = ModLoaderMod.get_unpacked_dir().path_join(MOD_DIR)

	# Register the scene
	register_scene()

func register_scene() -> void:
	var scene_path = mod_dir_path.path_join("GameFIles/main_scene.tscn")
	UqacWareAPI.addGame(scene_path)
