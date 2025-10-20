
extends CharacterBody2D

const SPEED = 200.0
const JUMP_VELOCITY = -300.0

@onready var foot: AudioStreamPlayer = $foot
@onready var jump: AudioStreamPlayer = $jump
@onready var clone_1: AudioStreamPlayer = $clone1
@onready var clone_2: AudioStreamPlayer = $clone2
@onready var clone = preload("res://scenes/anxiety.tscn")
@onready var collision_shape = $CollisionShape2D
@onready var gravity_detector = $GravityDetector
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_timer: Timer = $JumpTimer
@onready var hope_timer: Timer = $HopeTimer

var extra_gravity: Vector2 = Vector2.ZERO
var current_active_area: Vector2 = Vector2.ZERO
var overlapping_areas = {}
var last_hope_man

func _create_clone(is_inverse: bool):
	if is_on_floor() and PlayerVariables.clones.size() < 3:
			var cloneInstance = clone.instantiate()
			get_parent().add_child.call_deferred(cloneInstance) 
			cloneInstance.global_position = position
			cloneInstance.is_inverse = is_inverse
			PlayerVariables.clones.append(cloneInstance)
			clone_1.play()

func _jump() -> void:
	velocity.y = JUMP_VELOCITY
	jump.play()

	if current_active_area != Vector2.ZERO:
		jump_timer.start()
		PlayerVariables.gravity = 1960.0
		# print(PlayerVariables.gravity)

func _on_jump_timer_timeout() -> void:
	PlayerVariables.gravity = 980.0
	# print(PlayerVariables.gravity)

func _on_hope_timer_timeout() -> void:
	last_hope_man.is_available = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	var total_gravity = Vector2(PlayerVariables.gravity, PlayerVariables.gravity)  # Valor Default que está nas definições do Projeto
	extra_gravity = Vector2.ZERO
	current_active_area = Vector2.ZERO

	if Input.is_action_just_pressed("trauma_dump_01"):
		_create_clone(false)

	if Input.is_action_just_pressed("trauma_dump_02"):
		_create_clone(true)

	var closest_distance = INF
	var gravity_from_closest_area = Vector2.ZERO
	for area in gravity_detector.get_overlapping_areas():
		if area.has_method("get_gravity_at_point"):
			var current_distance = area.global_position.distance_to(global_position)

			if current_distance < closest_distance:
				current_active_area = area.global_position
				closest_distance = current_distance
				gravity_from_closest_area = area.get_gravity_at_point(global_position)

		if area.is_in_group("Hope"):
			if Input.is_action_just_pressed("good_dump_01") and area.is_available:
				global_position = area.global_position
				area.is_available = false
				last_hope_man = area
				hope_timer.start()


	var final_gravity = total_gravity + gravity_from_closest_area

	if not is_on_floor():
		velocity += final_gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		_jump()

	if Input.is_action_just_pressed("ui_down") and PlayerVariables.clones.front() != null:
		clone_2.play()
		PlayerVariables.clones.pop_front().queue_free()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_backwards", "move_forward")
	
	if direction != 0 and (not foot.playing) and is_on_floor():
		foot.play()

	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	#Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("walk")
	else:
		animated_sprite_2d.play("jump")

	if direction:
		velocity.x = direction * (SPEED)
	else:
		velocity.x = move_toward(velocity.x, 0, (SPEED))

	move_and_slide()
	queue_redraw()

func _draw() -> void:
	if current_active_area != Vector2.ZERO:
		draw_circle(to_local(current_active_area) + Vector2(0, -24), 4, Color.RED)

# @onready var ray_to_ground = $RayCast2D	
# @export var jump_delay = 0.2
# var is_preparing_jump = false

# if ray_to_ground.is_colliding():
	# var hit_point = ray_to_ground.get_collision_point()
	# var thing_hit = ray_to_ground.get_collider()
	
# if Input.is_action_just_pressed("ui_accept") and not is_preparing_jump and ray_to_ground.is_colliding():
	# _prepare_and_jump()
	
# func _prepare_and_jump():
	# is_preparing_jump = true
	
	# get_tree().create_timer(jump_delay).timeout
	# if is_on_floor():
		# velocity.y = JUMP_VELOCITY
	
	# is_preparing_jump = false
	
# var total_attraction_force = Vector2.ZERO
# var ATTRACTION_STRENGTH = (SPEED * 3)
# if PlayerVariables.clones.size() > 0:
	 #for i in range(PlayerVariables.clones.size()):
		# var distance_to_clone = PlayerVariables.clones[i].global_position - global_position
		# var distance = distance_to_clone.length()
		
		# if distance < 1.0:
			# continue # Skip this clone
			
		# var force = ATTRACTION_STRENGTH * (distance_to_clone.normalized() / distance)
		# total_attraction_force += force
		
# velocity += total_attraction_force
