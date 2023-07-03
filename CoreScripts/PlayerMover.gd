extends KinematicBody


onready var camera = $Camera
export var walking_speed = 6
export var running_speed = 12
export var mouse_sensitivity = 4.0
export var gravity = 400.0
export var step_size = 1.05
export var step_size_search_steps = 16
export var max_run_time = 5
export var run_cooldown = 5
var run_time = 0
var velocity = Vector3()
onready var used_to_be_on_floor = is_on_floor()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (is_running() and speed_pressed().length() > 0) or run_time > max_run_time:
		run_time += delta
	else:
		run_time -= delta
	if run_time > max_run_time + run_cooldown:
		run_time = 0

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Get input
	var speed = speed_pressed()
	
	# Fall down
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta

	# Move player. Key-related velocity is not accumulated.
	var vel = velocity + speed
	var vel_effective = vel
	var vel_moved = move_and_slide(vel_effective, Vector3.UP, true)
	var movement_error = (vel_moved - vel_effective) * Vector3(1, 0, 1)
	if movement_error.length() > 0:
		for i in range(1, step_size_search_steps + 1):
			var step_size_ = step_size * i / step_size_search_steps
			var movement = -movement_error / movement_error.length() * step_size_ * 2
			if not test_move(transform.translated(Vector3.UP * step_size_), movement):
				move_and_collide(Vector3.UP * step_size_)
				move_and_collide(movement)
				break
	
	
	if not is_on_floor() and used_to_be_on_floor:
		move_and_slide(Vector3.DOWN * speed.length() * 2)
	used_to_be_on_floor = is_on_floor()

# Handle mouse inputs
func _input(event):
	if event is InputEventMouseMotion:
		# Look up if pixels moves down; look right if pixels move left.
		var movement = -event.relative * mouse_sensitivity
		# Normalize by screen size
		movement /= get_viewport().size.x
		# Rotate us and the camera
		rotate_y(movement.x)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x + movement.y * 90, -90, 90)

# The speed keys are pointing in; view-dependent and incorporates walking/running.
func speed_pressed():
	var direction: Vector3 = direction_pressed()
	# Rotate to our view direction
	direction = transform.basis.xform(direction)
	# Run or walk
	if is_running() and run_time <= max_run_time:
		direction = direction * running_speed
	else:
		direction = direction * walking_speed
	return direction

# Checks if the character is running.
func is_running():
	return Input.is_action_pressed("run")

# Direction pressed keys are pointing in; view-independent.
func direction_pressed():
	var direction = Vector3.ZERO  # Vector3(0, -1, 0) if is_on_floor() else Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction += Vector3(0, 0, -1)
	if Input.is_action_pressed("right"):
		direction += Vector3(1, 0, 0)
	if Input.is_action_pressed("left"):
		direction += Vector3(-1, 0, 0)
	if Input.is_action_pressed("back"):
		direction += Vector3(0, 0, 1)
	return direction
