extends "res://CoreScripts/BaseMenu.gd"

onready var animation = $AnimationPlayer
# 0: waiting for key press
var state = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	animation.current_animation = "press_key"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if state == 0:
		for i in range(512):
			if Input.is_key_pressed(i):
				state = 1
				animation.current_animation = "menu"
				return
