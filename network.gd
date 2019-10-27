extends Node

func inProgress(tileLocV):
	var xPos= tileLocV.x
	var yPos = tileLocV.y - 1

	var http = HTTPClient.new()
	var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
	assert(err == OK)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		OS.delay_msec(500)
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	

	var fields = {"xPos": xPos, "yPos": yPos }
	var queryString = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	print("About to do PUT request: " + str(http.get_status()))
	
	http.request(
		HTTPClient.METHOD_PUT,
		"/puzzle_inprogress",
		headers,
		queryString
	)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		print("Requesting PUT...")
		yield(get_tree(), "idle_frame")
	
	print("After inprogress PUT request: " + str(http.get_status()))

	http.close()
		
func decProgress(tileLocV):
	var xPos= tileLocV.x
	var yPos = tileLocV.y - 1

	var http = HTTPClient.new()
	var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
	assert(err == OK)

	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
		http.poll()
		print("Connecting...")
		OS.delay_msec(500)
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	

	var fields = {"xPos": xPos, "yPos": yPos }
	var queryString = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]

	print("About to do PUT request: " + str(http.get_status()))
	
	http.request(
		HTTPClient.METHOD_PUT,
		"/puzzle_decprogress",
		headers,
		queryString
	)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
		http.poll()
		print("Requesting PUT...")
		yield(get_tree(), "idle_frame")
	
	print("After inprogress PUT request: " + str(http.get_status()))

	http.close()
	

func updateSolved(mouseLocV):
	var xPos= mouseLocV.x
	var yPos = mouseLocV.y - 1
	
	var http = HTTPClient.new()
	var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
	assert(err == OK)
	
	while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
	    http.poll()
	    print("Connecting...")
	    OS.delay_msec(500)
	
	assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
	
	var fields = {"xPos": xPos, "yPos": yPos }
	var queryString = http.query_string_from_dict(fields)
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	
	print("About to do PUT request: " + str(http.get_status()))
	
	http.request(
	    HTTPClient.METHOD_PUT,
	    "/puzzle_solved",
	    headers,
	    queryString
	)
	
	while http.get_status() == HTTPClient.STATUS_REQUESTING:
	    http.poll()
	    print("Requesting PUT...")
	    yield(get_tree(), "idle_frame")
	
	print("After puzzle_solved PUT request: " + str(http.get_status()))

	http.close()
	print("After close: " + str(http.get_status()))

