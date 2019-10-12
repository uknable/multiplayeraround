extends Node2D

# add following to exported index.html
# <meta http-equiv="Content-Security-Policy" content="upgrade-insecure-requests"> 

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
			
			print("Connection asserted? " + str(http.get_status()))
			assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
			
			var fields = {"flipped": false, "xPos": 0, "yPos": 0 }
			var queryString = http.query_string_from_dict(fields)
			var headers = ["Content-Type: application/x-www-form-urlencoded"]
			
			print("About to do PUT request: " + str(http.get_status()))
			
			var result = http.request(
				HTTPClient.METHOD_PUT,
				"/board_state",
				headers,
				queryString
			)

			while http.get_status() == HTTPClient.STATUS_REQUESTING:
				http.poll()
				print("Requesting PUT...")
				yield(get_tree(), "idle_frame")
			
			print("After PUT request: " + str(http.get_status()))
			 

