extends Area2D

var is_checkpoint_made = false

func _on_body_entered(body):
	if not is_checkpoint_made and body.is_in_group("Player"):
		var scene_path: String = GameVariables.game_controller.current_2d_scene.scene_file_path
		if scene_path != "":
			is_checkpoint_made = true
			print("Checkpoint at: " + scene_path)
			print(global_position)
			GameVariables.set_checkpoint(scene_path, global_position)
