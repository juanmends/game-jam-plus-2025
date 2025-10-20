extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		change_scene()
		
func change_scene() -> void:
	GameState.scene+=1
	var next_scene_path: String = "res://scenes/fase_%d.tscn" % GameState.scene
	PlayerVariables.clones.clear()
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
