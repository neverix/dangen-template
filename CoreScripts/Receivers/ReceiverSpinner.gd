extends Spatial

export var speed = 20
export var decay = 3
onready var parent = get_parent()
var spinning = false
var vel = Vector3.ZERO
var time = 0.0


func activate():
	spinning = true
	time = 0.0

func deactivate():
	spinning = false

func _process(delta):
	if not spinning:
		return
	time += delta
	parent.transform.basis = parent.transform.basis.rotated(Vector3.UP,
							delta * speed / pow(2, time * decay  # + 1
							))
