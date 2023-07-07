extends "res://CoreScripts/BaseMenu.gd"

var active = false
onready var ui = $PauseUI

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_tree().paused = active
	ui.visible = active
	if Input.is_action_just_pressed("pause"):
		active = not active

func resume():
	active = false
