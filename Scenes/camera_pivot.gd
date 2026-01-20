extends Node3D

# --- Settings ---
@export var disabled: bool = true
@export var rotation_speed: float = 0.5
@export var float_height: float = 0.5
@export var float_speed: float = 2.0

var time_passed: float = 0.0

func _process(delta):
	if disabled:
		return
		
	rotation.y += rotation_speed * delta
	
	time_passed += delta
	
	position.y = sin(time_passed * float_speed) * float_height
