extends Camera3D

@export var target: Node3D
@export var distance: float = 4.5
@export var height: float = 2.5
@export var follow_speed: float = 4.0

var direction_offset: Vector3 = Vector3.BACK

func _physics_process(delta):
	if not target:
		return

	if "velocity" in target and target.velocity.length() > 0.1:
		var flat_vel = Vector3(target.velocity.x, 0, target.velocity.z).normalized()
		direction_offset = direction_offset.lerp(flat_vel, follow_speed * delta)

	var target_pos = target.global_position
	var desired_pos = target_pos - (direction_offset * distance)
	desired_pos.y = target_pos.y + height

	global_position = global_position.lerp(desired_pos, follow_speed * delta)
	
	look_at(target_pos + Vector3(0, 1.0, 0))
