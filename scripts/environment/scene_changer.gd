extends Area2D

# auto_change = true -> o Player é transportado para a próxima fase automaticamente.
# auto_change = false -> o Player deve interagir com a Area2D antes de passar para a próxima fase.
@export var auto_change: bool = true
@export var next_scene: String = ""

@onready var sprite: Sprite2D = $Sprite2D
@onready var hint: AnimatedSprite2D = $ClickHint

var tween = null
var player_is_on_area = false
var next_scene_path: String

func _ready() -> void:
	next_scene_path = "res://scenes/levels/%s.tscn" % next_scene if next_scene != "" else ""
	sprite.visible = !auto_change
	hint.visible = false


func _process(_delta: float) -> void:
	# TODO: Implementar um Trigger de animação para o Player executar ao mudar de fase
	if player_is_on_area and Input.is_action_just_pressed("interact"):
		GameVariables.game_controller.change_2d_scene(next_scene_path)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		if auto_change:
			GameVariables.game_controller.change_2d_scene(next_scene_path)
		else:
			player_is_on_area = true
			fade_in()

func _on_body_exited(body: Node2D) -> void:
	if not auto_change and body.is_in_group("Player"):
		player_is_on_area = false
		fade_out()


func fade_in() -> void:
	hint.visible = true
	hint.play("Pressing Key")
	hint.modulate.a = 0.0
	if tween != null: tween.kill()  # stop any existing tween
	tween = create_tween()
	tween.tween_property($ClickHint, "modulate:a", 1.0, 0.3)

func fade_out() -> void:
	tween.kill()
	tween = create_tween()
	tween.tween_property($ClickHint, "modulate:a", 0.0, 0.3)
	tween.finished.connect(func(): hint.visible = false; hint.stop())
