extends Node2D

onready var tm = $TileMap

func _ready():
	pass

func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		print(mouseLoc, mouseLocV)

func goto_tile():
	pass

#func _unhandled_event(event):
#	if event is InputEventScreenTouch:
#		var mouseLoc = get_global_mouse_position()
#		var mouseLocV = tm.world_to_map(mouseLoc)