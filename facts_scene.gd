extends Node2D

func resetBoardState():
	$HTTPRequest.request("https://visibility-node.onrender.com/board_state_reset")

	
func _on_BackButton_pressed():
	get_tree().change_scene_to_file("res://board_state.tscn")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("Board Reset")
