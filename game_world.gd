extends Node2D

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)

func _on_httpButton_pressed():
	$HTTPRequest.request("https://sleepy-sands-19230.herokuapp.com/hello/bill")

func _on_osButton_pressed():
	if (OS.has_touchscreen_ui_hint()):
		$TextEdit.text = "true"
	else:
		$TextEdit.text = "false"
	
