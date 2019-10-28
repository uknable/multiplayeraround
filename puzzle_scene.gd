extends Node2D

onready var tm = $KeyboardTileMap

const letters = [ 
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
]

var object_car = preload("res://.import/object_car.png-022aa2099fc851e094ad375a17503716.stex")
var object_lights = preload("res://.import/object_lights.png-4936233f92d788303334be3d3e49151f.stex")
var object_tree = preload("res://.import/object_tree.png-58844deec650c0cec5a6d0500edc4e5b.stex")
var object_bus = preload("res://.import/object_bus.jpg-20a1c2014573cc1968d74f5b796e3a62.stex")

var filter_macular = preload("res://.import/filter_macular_degen.png-dca601ebfdb15fde30ee3084c4906d9c.stex")
var filter_retinopathy = preload("res://.import/filter_retinopathy.png-030e16ad7853741bfac2bb543650402c.stex")
var filter_glaucoma = preload("res://.import/filter_glaucoma.png-7584f9d8180d8bf9face0b72050f5f97.stex")
var filter_retinitis = preload("res://.import/filter_retinitis.png-ea84f1c3fe90cfad200933f86d03aa33.stex")

var objects = [
	[object_car, "car"],
	[object_lights, "traffic lights"],
	[object_tree, "tree"],
	[object_bus, "bus"]
]

var filters = [
	[filter_macular, "macular degeneration"],
	[filter_retinopathy, "retinopathy"],
	[filter_glaucoma, "glaucoma"],
	[filter_retinitis, "retinitis"]
]

var filter
var object

func _ready():

	randomize()
	
	object = objects[randi() % objects.size()]
	$PuzzleTexture.set_texture(object[0])

	filter = filters[randi() % objects.size()]
	$FilterTexture.set_texture(filter[0])
	$ImpairmentName.text = (filter[1])

	network.inProgress(Vector2(game_manager.xPos, game_manager.yPos))


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
	network.decProgress(Vector2(game_manager.xPos, game_manager.yPos))
	get_tree().change_scene("res://board_state.tscn")

func _on_SubmitButton_pressed():
	if ($TextEdit.text.to_lower() == object[1]):
		$WhatIsLabel.text = object[1].to_upper()
		print("Solved")
		$Feedback.show()
		$SubmitButton.hide()
		network.updateSolved(Vector2(game_manager.xPos, game_manager.yPos))
		
	else:
		print("incorrect")
		$StateLabel.text = "Incorrect try again."


func _on_ReturnToBoardButton_pressed():
	get_tree().change_scene("res://board_state.tscn")
