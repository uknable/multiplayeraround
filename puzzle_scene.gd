extends Node2D

onready var tm = $KeyboardTileMap

var xPos
var yPos

const letters = [ 
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
]

var puzzle_car_texture = preload("res://.import/puzzle_car.png-4bdaefad055c51c33b48dc3e99b2a3e0.stex")
var puzzle_lights_texture = preload("res://.import/puzzle_lights.png-41638f92209b4d26bc4614a9b416559a.stex")
var puzzle_tree_texture = preload("res://.import/puzzle_tree.png-37364b9cd1e713e6c6bbec9119470c59.stex")

var puzzles = { 
		"puzzle_car": [
			"car",
			"cataracts",
			puzzle_car_texture
		],
		"puzzle_lights": [
			"lights",
			"glaucoma",
			puzzle_lights_texture
		], 
		"puzzle_tree": [
			"tree",
			"retinography",
			puzzle_tree_texture
		]
}

var puzzle

func _ready():
	xPos = game_manager.xPos # if answer is correct, game manager flips tile
	yPos = game_manager.yPos

	var puzzleTextures = puzzles.keys()
	print(puzzleTextures)
	randomize()
	var puzzleTextureName = puzzleTextures[randi() % puzzleTextures.size()]
	print(puzzleTextureName)
	puzzle = puzzles.get(puzzleTextureName)
	$PuzzleTexture.set_texture(puzzle[2])
	$ImpairmentName.text = puzzle[1]

func _process(delta):
	#keyboard input
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		var cellv = tm.get_cellv(mouseLocV)
		print(mouseLocV, cellv)
		if (cellv >= 0 && cellv < 26):
			var currText = $TextEdit.text
			$TextEdit.text = currText + letters[cellv]
		if(cellv == 26):
			var currText = $TextEdit.text
			$TextEdit.text = currText.substr(0, currText.length()-1)
		if(cellv == 27):
			var currText = $TextEdit.text
			$TextEdit.text = currText + " "
		

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		var touchPos = get_canvas_transform().xform_inv(event.position)
		var touchPosV = tm.world_to_map(touchPos)
		print(touchPosV, tm.get_cellv(touchPosV))
		var cellv = tm.get_cellv(touchPosV)
		if (cellv >= 0 && cellv < 26):
			var currText = $TextEdit.text
			$TextEdit.text = currText + letters[cellv]
		if(cellv == 26):
			var currText = $TextEdit.text
			$TextEdit.text = currText.substr(0, currText.length()-1)
		if(cellv == 27):
			var currText = $TextEdit.text
			$TextEdit.text = currText + " "

func _on_BackButton_pressed():
	get_tree().change_scene("res://board_state.tscn")


func _on_SolveButton_pressed():
	if ($TextEdit.text.to_lower() == puzzle[0]):
		$StateLabel.text = "Solved! Taking you back to the board..."
		print("Solved")
		network.putRequest(Vector2(xPos, yPos))
		get_tree().change_scene("res://board_state.tscn")
	else:
		print("incorrect")
		$StateLabel.text = "Incorrect try again."



func _on_ClearTextButton_pressed():
	$TextEdit.text = ""
