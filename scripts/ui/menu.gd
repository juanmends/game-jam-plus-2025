extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MainContainer.size = Vector2(128.0, 128.0);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_new_game_pressed() -> void:
	pass # Replace with function body.


func _on_options_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	pass # Replace with function body.
