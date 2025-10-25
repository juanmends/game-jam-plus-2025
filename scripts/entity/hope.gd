extends Area2D

var tween = null
var is_available = true

func _ready() -> void:
	$AnimatedSprite2D.visible = false


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		fade_in()

func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player"):
		fade_out()


func fade_in() -> void:
	$AnimatedSprite2D.visible = true  # make sure it's visible before starting fade
	$AnimatedSprite2D.modulate.a = 0.0
	if tween != null: tween.kill()
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 1.0, 0.5) # fade to visible over 0.5s

func fade_out() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property($AnimatedSprite2D, "modulate:a", 0.0, 0.5) # fade to invisible over 0.5s
	tween.finished.connect(func():
		$AnimatedSprite2D.visible = false)  # hide completely when done

# func _draw() -> void:
	# draw_circle($AnimatedSprite2D.global_position - Vector2(0, -16), 58 , Color.RED)
