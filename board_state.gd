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

	$LoadingAnimation.show()


#for mouse input
func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):

		var mouseLoc = get_global_mouse_position()
		var mouseLocV = btm.world_to_map(mouseLoc)

		if(mouseLocV.x >= 0 && mouseLocV.x < 2 && mouseLocV.y >= 1 && mouseLocV.y < 4):

			var tile = [int(mouseLocV.x), int(mouseLocV.y)-1]
			var progress = game_manager.ticksSolved[tile] + game_manager.ticksInProgress[tile]
			
			if(btm.get_cellv(mouseLocV) == 6):
				if(progress < 3):
					$LoadingAnimation.show()
					game_manager.changeIntoPuzzle(mouseLocV)
				else:
					$Label.text = "That tile has no available slots!"
			

	


# for touch input
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:

		var touchPos = get_canvas_transform().xform_inv(event.position)
		var touchPosV = btm.world_to_map(touchPos)

		if(touchPosV.x >= 0 && touchPosV.x < 2 && touchPosV.y >= 1 && touchPosV.y < 4):

			var tile = [int(touchPosV.x), int(touchPosV.y)-1]
			var progress = game_manager.ticksSolved[tile] + game_manager.ticksInProgress[tile]
			
			if(btm.get_cellv(touchPosV) == 6 && progress < 3):
				$LoadingAnimation.show()
				game_manager.changeIntoPuzzle(touchPosV)

func _on_Timer_timeout():
	getBoardState()

func getBoardState():
	$GetBoardState.request("https://sleepy-sands-19230.herokuapp.com/board_state")
	print($GetBoardState.get_http_client_status())

func _on_GetBoardState_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	board_state = json.result.get('info')

	$LoadingAnimation.hide()

	for row in board_state:
		# tile in row is an Array of Float(Real)
		# change to Array of Int to use for tileCoords
		
		# update progress indicator
		var tile = [int(row.tile[0]), int(row.tile[1])]
		var tileProgress = tileProgressCoords.get(tile)

		#update ticksSolved in game_manager
		game_manager.ticksSolved.erase(tile)
		game_manager.ticksSolved[tile] = row.solved

		#update ticksInProgress in game_manager
		game_manager.ticksInProgress.erase(tile)
		game_manager.ticksInProgress[tile] = row.in_progress



		# color progress indicators
		# reset
		for i in 3:
			ptm.set_cellv(
				tileProgress[i],
				2
			)

		var progress = 0
		
		# colour green for solved
		for i in range(0, row.solved):
			ptm.set_cellv(
				tileProgress[progress],
				0
			)
			progress=progress+1
		
		# colour orange for inprogress
		for i in range(0, row.in_progress):
			ptm.set_cellv(
				tileProgress[progress],
				1
			)
			progress=progress+1
		

		if(row.solved>=3): # Checking which tile is flipped
			var flippedTile = [int(row.tile[0]), int(row.tile[1])]
			btm.set_cellv(
				Vector2(flippedTile[0], flippedTile[1]+1), 
				tileCoords.get(flippedTile)
			)

	checkIfCompleted(board_state)


func checkIfCompleted(board_state):
	print("checking if completed")

	var tilesFlipStates = []
	for row in board_state:
		tilesFlipStates.append(row.solved)

	if (tilesFlipStates.min() == 3):
		print("completed! switching to facts scene")
		get_tree().change_scene("res://facts_scene.tscn")
