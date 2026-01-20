extends CharacterBody3D

@export var walk_speed: float = 4.0
@export var run_speed: float = 7.0
@export var roll_speed: float = 12.0
@export var jump_force: float = 5.5
@export var gravity: float = 14.0
@export var acceleration: float = 8.0 * 2
@export var deceleration: float = 10.0 * 2
@export var rotation_speed: float = 10.0

@onready var visuals = $Visuals
@onready var anim = $AnimationPlayer

var is_rolling: bool = false
var is_sprinting: bool = false

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_rolling:
		move_and_slide()
		return

	if Input.is_action_just_pressed("roll") and is_on_floor():
		start_roll()

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3.ZERO
	
	var cam = get_viewport().get_camera_3d()
	if cam:
		direction = (cam.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		direction.y = 0

	is_sprinting = Input.is_action_pressed("sprint")
	var target_speed = run_speed if is_sprinting else walk_speed
	
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * target_speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, direction.z * target_speed, acceleration * delta)
		
		var target_angle = atan2(direction.x, direction.z)
		visuals.rotation.y = lerp_angle(visuals.rotation.y, target_angle, rotation_speed * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration * delta)
		velocity.z = move_toward(velocity.z, 0, deceleration * delta)

	move_and_slide()

func start_roll():
	is_rolling = true
	
	var roll_dir = visuals.transform.basis.z
	velocity.x = roll_dir.x * roll_speed
	velocity.z = roll_dir.z * roll_speed
	
	await get_tree().create_timer(0.6).timeout
	is_rolling = false
