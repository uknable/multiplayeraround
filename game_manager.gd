extends Node

var xPos
var yPos
var ticksSolved = { 
	[0,0]: 0, 
	[1,0]: 0, 
	[0,1]: 0, 
	[1,1]: 0, 
	[0,2]: 0, 
	[1,2]: 0
}
var ticksInProgress = { 
	[0,0]: 0, 
	[1,0]: 0, 
	[0,1]: 0, 
	[1,1]: 0, 
	[0,2]: 0, 
	[1,2]: 0
}

func _process(delta):
	#if (OS.has_touchscreen_ui_hint()):
	pass

func changeIntoPuzzle(inputPosition):
	get_tree().change_scene("res://puzzle_scene.tscn")
	xPos = inputPosition.x
	yPos = inputPosition.y

