extends Area2D

@onready var tween := create_tween()

var is_available = true

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		fade_in()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		fade_out()


func fade_in() -> void:
	visible = true
	$AnimatedSprite2D.visible = true  # make sure it's visible before starting fade
	modulate.a = 0.0
	tween.kill()  # stop any existing tween
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5) # fade to visible over 0.5s


func fade_out() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5) # fade to invisible over 0.5s
	tween.finished.connect(func():
		$AnimatedSprite2D.visible = false; visible = false)  # hide completely when done

# func _draw() -> void:
	# draw_circle($AnimatedSprite2D.global_position - Vector2(0, -16), 58 , Color.RED)
