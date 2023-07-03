extends KinematicBody


onready var camera = $Camera
export var walking_speed = 100.0
export var running_speed = 200.0
export var mouse_sensitivity = 4.0
export var gravity = 9.81
var velocity = Vector3()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Fall down
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * delta

	# Move player
	var vel = speed_pressed() * delta
	velocity.x = vel.x
	velocity.z = vel.z
	move_and_slide(velocity, Vector3.UP, true)

# Handle mouse inputs
func _input(event):
	if event is InputEventMouseMotion:  # and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
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
	if is_running():
		direction = direction * running_speed
	else:
		direction = direction * walking_speed
	return direction

# Checks if the character is running.
func is_running():
	return Input.is_action_pressed("run")

# Direction pressed keys are pointing in; view-independent.
func direction_pressed():
	var direction = Vector3.ZERO
	if Input.is_action_pressed("forward"):
		direction += Vector3(0, 0, -1)
	if Input.is_action_pressed("right"):
		direction += Vector3(1, 0, 0)
	if Input.is_action_pressed("left"):
		direction += Vector3(-1, 0, 0)
	if Input.is_action_pressed("back"):
		direction += Vector3(0, 0, 1)
	return direction
