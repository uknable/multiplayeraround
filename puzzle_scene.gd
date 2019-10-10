extends Node2D

var correct = false
var answer = "car"

func _on_BackButton_pressed():
	pass 

func _on_SubmitButton_pressed():
	var guess = $testAnswer.text
	if (guess == answer):
		var 
		$HTTPRequest.request(
	pass 


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	pass # Replace with function body.
