extends Node

export var change_to = "res://Scenes/TestScene.tscn"

func activate():
	get_tree().change_scene(change_to)
