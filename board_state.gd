extends Node2D

# add the following to exported index.html
# <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"> 

onready var tm = $TileMap
var tileCoords = { 
	[0,0]: 0, 
	[1,0]: 1, 
	[0,1]: 2, 
	[1,1]: 3, 
	[0,2]: 4, 
	[1,2]: 5
}

var _timer = null

func _ready():
	getBoardState()

	_timer = Timer.new()
	add_child(_timer)

	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(2.0)
	_timer.set_one_shot(false)
	_timer.start()


#for mouse input
func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		if(mouseLocV.x >= 0 && mouseLocV.x < 2 && mouseLocV.y >= 1 && mouseLocV.y < 4):
			print(mouseLocV)
			game_manager.changeIntoPuzzle(mouseLocV)

# for touch input
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		var touchPos = get_canvas_transform().xform_inv(event.position)
		var touchPosV = tm.world_to_map(touchPos)
		if(touchPosV.x >= 0 && touchPosV.x < 2 && touchPosV.y >= 1 && touchPosV.y < 4):
			print(touchPosV)
			game_manager.changeIntoPuzzle(touchPosV)

func _on_Timer_timeout():
	getBoardState()

func getBoardState():
	$GetBoardState.request("https://sleepy-sands-19230.herokuapp.com/board_state")
	$Label.text = "Loading..."

func _on_GetBoardState_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var board_state = json.result.get('info')

	for row in board_state:
		# tile in row is an Array of Float(Real)
		# change to Array of Int to use for tileCoords
		
		if(row.flipped):
			var flippedTile = [int(row.tile[0]), int(row.tile[1])]
			tm.set_cellv(
			Vector2(flippedTile[0], flippedTile[1]), 
			tileCoords.get(flippedTile)
		)
	$Label.text = "Got board state."
		
	getTileProgress()
	checkIfCompleted(board_state)

func getTileProgress():
	
	pass

func checkIfCompleted(board_state):
	print("checking if completed")

	var tilesFlipStates = []
	for row in board_state:
		tilesFlipStates.append(row.flipped)
	
	var allFlipped = tilesFlipStates.has(false)
	
	print(allFlipped)
	
	if (allFlipped == false):
		print("switching to facts scene")
		get_tree().change_scene("res://facts_scene.tscn")