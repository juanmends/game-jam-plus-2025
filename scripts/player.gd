
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var clone = preload("res://scenes/clone.tscn")
@onready var collision_shape = $CollisionShape2D
@onready var ray_to_ground = $RayCast2D

@export var jump_delay = 0.2

var is_preparing_jump = false

func _prepare_and_jump():
	is_preparing_jump = true
	
	get_tree().create_timer(jump_delay).timeout
	if is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	is_preparing_jump = false

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# if ray_to_ground.is_colliding():
		# var hit_point = ray_to_ground.get_collision_point()
		# var thing_hit = ray_to_ground.get_collider()
		
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and ray_to_ground.is_colliding():
		velocity.y += JUMP_VELOCITY

	if Input.is_action_just_pressed("ui_accept") and not is_preparing_jump and ray_to_ground.is_colliding():
		_prepare_and_jump()

	if Input.is_action_just_pressed("trauma_dump") and PlayerVariables.clones.size() < 3:
		var cloneInstance = clone.instantiate()
		get_parent().add_child.call_deferred(cloneInstance) 
		cloneInstance.global_position = Vector2(position.x, position.y + collision_shape.shape.size.y)
		PlayerVariables.clones.append(cloneInstance)
		print(PlayerVariables.clones[0])

	if Input.is_action_just_pressed("ui_down") and PlayerVariables.clones.front() != null:
		PlayerVariables.clones.pop_front().queue_free()

	var total_attraction_force = Vector2.ZERO
	var ATTRACTION_STRENGTH = (SPEED * 3)
	if PlayerVariables.clones.size() > 0:
		for i in range(PlayerVariables.clones.size()):
			var distance_to_clone = PlayerVariables.clones[i].global_position - global_position
			var distance = distance_to_clone.length()
			
			if distance < 1.0:
				continue # Skip this clone
				
			var direction = distance_to_clone.normalized()
			var force = ATTRACTION_STRENGTH * (direction / distance)
			total_attraction_force += force
			
	velocity += total_attraction_force

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_backwards", "move_forward")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
