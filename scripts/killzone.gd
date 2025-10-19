extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	timer.start()

func _on_timer_timeout() -> void:
	PlayerVariables.clones.clear()
	get_tree().reload_current_scene()
