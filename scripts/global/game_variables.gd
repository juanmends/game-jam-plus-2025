extends Node

var game_controller: GameController

var all_files = DirAccess.get_files_at("res://scenes/levels")
var checkpoint_scene: String = ""
var checkpoint_position: Vector2

func set_checkpoint(scene_path: String, position: Vector2) -> void:
	if scene_path == "":
		push_error("Endereço inválido de cena do Checkpoint: " + scene_path)
		return
	checkpoint_scene = scene_path
	checkpoint_position = position

func has_checkpoint() -> bool:
	print(all_files.has(checkpoint_scene))
	print(all_files.find(checkpoint_scene))
	return all_files.find(checkpoint_scene) > -1
