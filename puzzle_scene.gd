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

#tool images
var object_cane = preload("res://.import/object_whitecane.png-5d6755afded56c98c683179c3efbcae6.stex")
var object_braille = preload("res://.import/object_braille.png-ee80714fd55dd93f208035dbb8122516.stex")
var object_tactile = preload("res://.import/object_tactilepaving.png-d82c2eb0cef3134a9a5e78294501ea6c.stex")

var sound_car = load("res://assets/sounds/BMW_driveby.wav")
var sound_lights = load("res://assets/sounds/trafficlights.wav") 
var sound_tree = load("res://assets/sounds/tree.wav")
var sound_bus = load("res://assets/sounds/bus_stopandgo.wav")

var filter_macular = preload("res://.import/filter_macular_degen.png-dca601ebfdb15fde30ee3084c4906d9c.stex")
var filter_retinopathy = preload("res://.import/filter_retinopathy.png-030e16ad7853741bfac2bb543650402c.stex")
var filter_glaucoma = preload("res://.import/filter_glaucoma.png-7584f9d8180d8bf9face0b72050f5f97.stex")
var filter_retinitis = preload("res://.import/filter_retinitis.png-ea84f1c3fe90cfad200933f86d03aa33.stex")

var objects = [
	[object_car, "car", sound_car, "impairments"],
	[object_lights, "traffic lights", sound_lights, "impairments"],
	[object_tree, "tree", sound_tree, "impairments"],
	[object_bus, "bus", sound_bus, "impairments"],
	[object_cane, "white cane", null, "Helps note upcoming obstacles and the ground surface"],
	[object_braille, "braille", null, "System to read and write through arrangement of raised dots"],
	[object_tactile, "tactile paving", null, "Gives warning for change in terrain and traffic stops"]
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
	if (object[2] != null) :
		$HintSound.stream = object[2]
	else:
		$HintButton.hide()

	if (object[3] == "impairments"):
		filter = filters[randi() % filters.size()]
		$FilterTexture.set_texture(filter[0])
		$ImpairmentName.text = filter[1]
	else:
		$FilterTexture.hide()
		$ImpairmentName.text = ""
		$QuestionType.text = "Tools for Impairment"
		$Question.text = object[3]

	inProgress(Vector2(game_manager.xPos, game_manager.yPos))


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
	decProgress(Vector2(game_manager.xPos, game_manager.yPos))

func _on_SubmitButton_pressed():
	if ($TextEdit.text.to_lower() == object[1]):
		updateSolved(Vector2(game_manager.xPos, game_manager.yPos))
		$WhatIsLabel.text = object[1].to_upper()
		$Feedback.show()
		$SubmitButton.hide()
	else:
		$TextEdit.clear()
		$TextEdit.placeholder_text = "Incorrect! Try Again"

func _on_ReturnToBoardButton_pressed():
	get_tree().change_scene("res://board_state.tscn")

func inProgress(tileLocV):
	$LoadingAnimation.show()
	var xPos= tileLocV.x
	var yPos = tileLocV.y - 1

	var http = HTTPClient.new()
	var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
	assert(err == OK)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		yield(get_tree(), "idle_frame")
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	

	var fields = {"xPos": xPos, "yPos": yPos }
	var queryString = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	print("About to do PUT request: " + str(http.get_status()))
	
	http.request(
		HTTPClient.METHOD_PUT,
		"/puzzle_inprogress",
		headers,
		queryString
	)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		yield(get_tree(), "idle_frame")
	
	print("After inprogress PUT request: " + str(http.get_status()))

	http.close()
	$LoadingAnimation.hide()
		
func decProgress(tileLocV):
	$LoadingAnimation.show()
	var xPos= tileLocV.x
	var yPos = tileLocV.y - 1

	var http = HTTPClient.new()
	var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
	assert(err == OK)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		
		print("Connecting...")
		yield(get_tree(), "idle_frame")
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	

	var fields = {"xPos": xPos, "yPos": yPos }
	var queryString = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	print("About to do PUT request: " + str(http.get_status()))
	
	http.request(
		HTTPClient.METHOD_PUT,
		"/puzzle_decprogress",
		headers,
		queryString
	)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		yield(get_tree(), "idle_frame")
	
	print("After inprogress PUT request: " + str(http.get_status()))

	http.close()
	$LoadingAnimation.hide()
	game_manager.changeIntoBoard()
	

func updateSolved(mouseLocV):
	$LoadingAnimation.show()
	var xPos= mouseLocV.x
	var yPos = mouseLocV.y - 1
	
	var http = HTTPClient.new()
	var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
	assert(err == OK)
	
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		yield(get_tree(), "idle_frame")
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	
	var fields = {"xPos": xPos, "yPos": yPos }
	var queryString = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	
	print("About to do PUT request: " + str(http.get_status()))
	
	http.request(
	    HTTPClient.METHOD_PUT,
	    "/puzzle_solved",
	    headers,
	    queryString
	)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
	    http.poll()
	    yield(get_tree(), "idle_frame")
	
	print("After puzzle_solved PUT request: " + str(http.get_status()))

	http.close()
	print("After close: " + str(http.get_status()))
	$LoadingAnimation.hide()

func _on_HintButton_pressed():
	$HintSound.play()
