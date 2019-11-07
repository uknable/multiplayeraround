extends Node2D

func resetBoardState():
	$HTTPRequest.request("https://sleepy-sands-19230.herokuapp.com/board_state_reset")

	
func _on_BackButton_pressed():
	get_tree().change_scene("res://board_state.tscn")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Board Reset")
