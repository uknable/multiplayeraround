extends Node2D

func _ready():
	if (OS.has_touchscreen_ui_hint()):
		$TextEdit.text = "true"
	else:
		$TextEdit.text = "false"

func _on_httpButton_pressed():
	$HTTPRequestGetUsers.request("https://sleepy-sands-19230.herokuapp.com/users")

func _on_HTTPRequestGetUsers_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	var jsonResult = json.result.get('info').values()
	print(jsonResult[3][1])
	$getUsersResult.set_text(jsonResult[3][1]['name'])
	
	
