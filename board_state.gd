extends Node2D

# add the following to exported index.hbtml
# <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"> 

onready var btm = $BoardTileMap
onready var ptm = $ProgressTileMap

var tileCoords = { 
	[0,0]: 0, 
	[1,0]: 1, 
	[0,1]: 2, 
	[1,1]: 3, 
	[0,2]: 4, 
	[1,2]: 5
}

var tileProgressCoords = {
	[0,0]: [Vector2(1, 16), Vector2(2, 16), Vector2(3, 16)], 
	[1,0]: [Vector2(6, 16), Vector2(7, 16), Vector2(8, 16)],
	[0,1]: [Vector2(1, 32), Vector2(2, 32), Vector2(3, 32)],
	[1,1]: [Vector2(6, 32), Vector2(7, 32), Vector2(8, 32)],
	[0,2]: [Vector2(1, 48), Vector2(2, 48), Vector2(3, 48)],
	[1,2]: [Vector2(6, 48), Vector2(7, 48), Vector2(8, 48)]
}

var _timer = null
var board_state = {}

const TIMER_LENGTH = 2.0

func _ready():
	getBoardState()

	# Timer calls getBoardState() every 2 seconds
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.set_wait_time(TIMER_LENGTH)
	_timer.set_one_shot(false)
	_timer.start()


#for mouse input
func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = btm.world_to_map(mouseLoc)
		var mouseLocVptm = ptm.world_to_map(mouseLoc)
		print(mouseLocVptm)
		if(mouseLocV.x >= 0 && mouseLocV.x < 2 && mouseLocV.y >= 1 && mouseLocV.y < 4):
			game_manager.changeIntoPuzzle(mouseLocV)

# for touch input
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		var touchPos = get_canvas_transform().xform_inv(event.position)
		var touchPosV = btm.world_to_map(touchPos)
		if(touchPosV.x >= 0 && touchPosV.x < 2 && touchPosV.y >= 1 && touchPosV.y < 4):
			game_manager.changeIntoPuzzle(touchPosV)

func _on_Timer_timeout():
	getBoardState()

func getBoardState():
	$GetBoardState.request("https://sleepy-sands-19230.herokuapp.com/board_state")
	$Label.text = "Loading..."

func _on_GetBoardState_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	board_state = json.result.get('info')


	for row in board_state:
		# tile in row is an Array of Float(Real)
		# change to Array of Int to use for tileCoords
		
		if(row.flipped): # Checking which tile is flipped
			var flippedTile = [int(row.tile[0]), int(row.tile[1])]
			btm.set_cellv(
				Vector2(flippedTile[0], flippedTile[1]), 
				tileCoords.get(flippedTile)
			)

		# update progress indicator
		var tile = [int(row.tile[0]), int(row.tile[1])]
		var tileProgress = tileProgressCoords.get(tile)

		#update ticksSolved in game_manager
		print(game_manager.ticksSolved)
		game_manager.ticksSolved.erase(tile)
		game_manager.ticksSolved[tile] = row.solved
		
		print(game_manager.ticksSolved)
		print("updated ticksSolved")

		# color solved indicator
		for i in range(0, row.solved):
			
			ptm.set_cellv(
				tileProgress[i],
				0
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
	
	if (allFlipped == false):
		print("completed! switching to facts scene")
		get_tree().change_scene("res://facts_scene.tscn")