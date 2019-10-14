extends Node

var xPos
var yPos

func _process(delta):
	#if (OS.has_touchscreen_ui_hint()):
	pass

func changeIntoPuzzle(inputPosition):
	get_tree().change_scene("res://puzzle_scene.tscn")
	xPos = inputPosition.x
	yPos = inputPosition.y