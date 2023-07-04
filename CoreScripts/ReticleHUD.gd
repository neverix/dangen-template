extends Control

export var mouse_sensitivity = 2.0
export var ray_max = 100
onready var reticle = $Reticle
onready var animation = $AnimationPlayer

# 0: can be used to select things
# 1: deactivated
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative * mouse_sensitivity
		reticle.rect_position += movement
		reticle.rect_position.x = max(0, min(rect_size.x, reticle.rect_position.x))
		reticle.rect_position.y = max(0, min(rect_size.y, reticle.rect_position.y))
	if state == 0 and event is InputEventMouseButton and event.button_index == 1 and event.pressed:
		activate()

func _process(delta):
	if state != 0:
		return
	if cast_ray():
		animation.current_animation = "focused"
	else:
		animation.current_animation = "unfocused"

func activate():
	var object = cast_ray()
	if not object:
		return
	animation.current_animation = "activated"
	state = 1

func cast_ray():
	var coords = reticle.rect_global_position
	var camera = get_viewport().get_camera()
	var source = camera.project_ray_origin(coords)
	var direction = camera.project_ray_normal(coords)
	var dss = get_parent().get_world().direct_space_state
	return dss.intersect_ray(source, direction * ray_max)
