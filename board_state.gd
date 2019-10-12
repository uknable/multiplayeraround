extends Node2D

# add the following to exported index.html
# <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"> 

onready var tm = $TileMap

#for mouse input
func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		print(mouseLoc, mouseLocV)
		network.putRequest(mouseLocV)
	
	# get board_state

# for touch input
func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		var touchPos = get_canvas_transform().xform_inv(event.position)
		var touchPosV = tm.world_to_map(touchPos)
		print(touchPos, touchPosV)
		network.putRequest(touchPosV)
