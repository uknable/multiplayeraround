extends Node2D

onready var tm = $TileMap

func _ready():
	pass

func _process(delta):
	if (Input.is_action_just_pressed("ui_click")):
		var mouseLoc = get_global_mouse_position()
		var mouseLocV = tm.world_to_map(mouseLoc)
		print(mouseLoc, mouseLocV)
		if (mouseLocV == Vector2(0,1)):
			var http = HTTPClient.new()
			var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
			assert(err == OK)
			
			while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
				http.poll()
				print("Connecting...")
				OS.delay_msec(500)
			
			assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
			
			
			var fields = {"flipped": false, "xPos": 0, "yPos": 0 }
			var queryString = http.query_string_from_dict(fields)
			var headers = ["Content-Type: application/x-www-form-urlencoded", "Content-Length: " + str(queryString.length())]
			var result = http.request(
				HTTPClient.METHOD_PUT,
				"/board_state",
				headers,
				queryString
			)

func goto_tile():
	pass
	
func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
