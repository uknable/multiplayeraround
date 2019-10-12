extends Node

func putRequest(mouseLocV):
    var xPos= mouseLocV.x
    var yPos = mouseLocV.y - 1

    var http = HTTPClient.new()
    var err = http.connect_to_host("sleepy-sands-19230.herokuapp.com")
    assert(err == OK)
    
    while http.get_status() == HTTPClient.STATUS_CONNECTING or http.get_status() == HTTPClient.STATUS_RESOLVING:
        http.poll()
        print("Connecting...")
        OS.delay_msec(500)
    
    print("Connection asserted? " + str(http.get_status()))
    assert(http.get_status() == HTTPClient.STATUS_CONNECTED)
    
    var fields = {"flipped": false, "xPos": xPos, "yPos": yPos }
    var queryString = http.query_string_from_dict(fields)
    var headers = ["Content-Type: application/x-www-form-urlencoded"]
    
    print("About to do PUT request: " + str(http.get_status()))
    
    http.request(
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
