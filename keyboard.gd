extends Node2D

onready var tm = $TileMap

func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		print(mouseLocV, tm.get_cellv(mouseLocV))
