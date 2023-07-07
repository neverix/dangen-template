extends Node


func quit():
	get_tree().quit()

func save():
	print(get("Script Variables"))

# TODO: add save file parameter
func open_game():
	get_tree().change_scene("res://Scenes/TestScene.tscn")
