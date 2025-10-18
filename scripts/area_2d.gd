extends Area2D

@export_range(0.0, 1000.0, 10.0)
var gravity_range: float = 500.0

@onready var orientation = 1 if self.get_parent().is_inverse else -1

# Optional: if the Area2D is circular, you can base gravity on distance to center
func get_gravity_at_point(point: Vector2) -> Vector2:
	var direction = (global_position - point).normalized()
	var distance = global_position.distance_to(point)
	var falloff = clamp(1.0 - (distance / gravity_range), 0.0, 1.0)
	var gravity_strength = gravity * 0.65 if orientation < 0 else gravity
	return direction * gravity_strength * falloff * orientation
