extends Node2D

var correct = false
var answer = "car"

func _on_BackButton_pressed():
	pass 

func _on_SubmitButton_pressed():
	var guess = $testAnswer.text
	if (guess == answer):
		$HTTPRequest.request("https://sleepy-sands-19230.herokuapp.com/board_state")
	pass 


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
