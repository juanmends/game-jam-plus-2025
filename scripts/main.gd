class_name GameController extends Node

@export var world_2d: Node2D
@export var user_interface: Control

@export_range(0.0, 5.0)
var default_world_2d: int

var current_2d_scene = null;
var current_ui_scene = null;

func _ready() -> void:
	GameVariables.game_controller = self
	current_ui_scene = user_interface.get_child(0);

func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	# print_tree_pretty()
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	var packed_scene = load(new_scene)
	if packed_scene is PackedScene:
		var new_scene_instance = packed_scene.instantiate()
		world_2d.add_child(new_scene_instance)
		current_2d_scene = new_scene_instance
		get_tree().current_scene = current_2d_scene
	else:
		push_error("Invalid 2D Scene address: " + new_scene)

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_ui_scene != null:
		if delete:
			current_ui_scene.queue_free()
		elif keep_running:
			current_ui_scene.visible = false
		else:
			user_interface.remove_child(current_ui_scene)
	var packed_scene = load(new_scene)
	if packed_scene is PackedScene:
		var new_scene_instance = packed_scene.instantiate()
		user_interface.add_child(new_scene_instance)
		current_ui_scene = new_scene_instance
	else:
		push_error("Invalid GUI Scene address: " + new_scene)

func reset_level() -> void:
	PlayerVariables.clones.clear()
	# print(GameVariables.has_checkpoint())
	# if GameVariables.has_checkpoint():
		# change_2d_scene(GameVariables.checkpoint_scene)
		# current_2d_scene.get_node("Player").global_position = GameVariables.checkpoint_position
	# else:
		# change_2d_scene(current_2d_scene.scene_file_path)
