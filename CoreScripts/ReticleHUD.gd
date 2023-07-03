extends Control

export var mouse_sensitivity = 2.0
onready var reticle = $Reticle

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventMouseMotion:
		var movement = event.relative * mouse_sensitivity
		reticle.rect_position += movement
		reticle.rect_position.x = max(0, min(rect_size.x, reticle.rect_position.x))
		reticle.rect_position.y = max(0, min(rect_size.y, reticle.rect_position.y))
	elif event is InputEventMouseButton and event.button_index == 0:
		activate()

func activate():
	pass
