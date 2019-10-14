extends Node2D

var puzzle_car = preload("res://.import/puzzle_car.png-4bdaefad055c51c33b48dc3e99b2a3e0.stex")
var puzzle_lights = preload("res://.import/puzzle_lights.png-41638f92209b4d26bc4614a9b416559a.stex")
var puzzle_tree = preload("res://.import/puzzle_tree.png-37364b9cd1e713e6c6bbec9119470c59.stex")

var xPos
var yPos
var puzzles = { 
	puzzle_car: "cataracts", 
	puzzle_lights: "glaucoma", 
	puzzle_tree: "retinography" 
}

func _ready():
	xPos = game_manager.xPos
	yPos = game_manager.yPos

	var puzzleTextures = puzzles.keys()
	var puzzleTexture = puzzleTextures[randi() % puzzleTextures.size()]
	$ImpairmentName.text = puzzles.get(puzzleTexture)
	$PuzzleTexture.set_texture(puzzleTexture)

func _on_BackButton_pressed():
	pass # Replace with function body.


func _on_SolveButton_pressed():
	pass # Replace with function body.


func _on_TextEdit_focus_entered():
	$ImpairmentName.text = "Entered focus"
	OS.show_virtual_keyboard("")


func _on_TextEdit_focus_exited():
	$ImpairmentName.text = OS.get_name()
