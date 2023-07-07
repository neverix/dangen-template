extends Node


func activate():
	for child in get_children():
		if child.has_method("activate"):
			child.activate()

func deactivate():
	for child in get_children():
		if child.has_method("deactivate"):
			child.deactivate()
