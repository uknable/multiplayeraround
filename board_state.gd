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

func _ready():
	getBoardState()

#for mouse input
func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		if(mouseLocV.x >= 0 && mouseLocV.x < 2 && mouseLocV.y >= 1 && mouseLocV.y < 4):
			print(mouseLocV)
			network.putRequest(mouseLocV)

# for touch input
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		var touchPos = get_canvas_transform().xform_inv(event.position)
		var touchPosV = tm.world_to_map(touchPos)
		if(touchPosV.x >= 0 && touchPosV.x < 2 && touchPosV.y >= 1 && touchPosV.y < 4):
			print(touchPosV)
			network.putRequest(touchPosV)

func getBoardState():
	$GetBoardState.request("https://sleepy-sands-19230.herokuapp.com/board_state")

func _on_GetBoardState_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var board_state = json.result.get('info')
	
	print("Got Board State")

	for row in board_state:
		# tile in row is an Array of Float(Real)
		# change to Array of Int to use for tileCoords
		
		if(row.flipped):
			var flippedTile = [int(row.tile[0]), int(row.tile[1])]
			tm.set_cellv(
			Vector2(flippedTile[0], flippedTile[1]), 
			tileCoords.get(flippedTile)
		) 


func _on_ButtonGetBoardState_pressed():
	getBoardState()
