extends Node2D

func _on_JoinButton_pressed():
	get_tree().change_scene_to_file("res://board_state.tscn")
