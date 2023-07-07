extends Area


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "activate_parent")

func activate_parent(body):
	var parent = get_parent()
	if parent.has_method("activate"):
		parent.activate()