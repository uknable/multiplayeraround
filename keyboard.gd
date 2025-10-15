extends Node2D

@onready var tm = $TileMap

const letters = [ 
	"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
	"N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
]

func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.local_to_map(mouseLoc)
		var cellv = tm.get_cellv(mouseLocV)
		print(mouseLocV, cellv)
		if (cellv >= 0 && cellv < 26):
			var currText = $TextEdit.text
			$TextEdit.text = currText + letters[cellv]
		

func _input(event):
	if not event is InputEventScreenTouch:
		return
	if event.pressed:
		var touchPos = get_canvas_transform()(event.position) * 
		var touchPosV = tm.local_to_map(touchPos)
		print(touchPosV, tm.get_cellv(touchPosV))
