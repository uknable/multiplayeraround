extends CanvasLayer


func _ready():
	network.connect("server_created", self, "_on_ready_to_play")

func _on_btCreate_pressed():
	# Gather values from the GUI and fill the network.server_info dictionary
	if (!$PanelHost/txtServerName.text.empty()):
		network.server_info.name = $PanelHost/txtServerName.text
	network.server_info.max_players = int($PanelHost/txtMaxPlayers.value)
	network.server_info.used_port = int($PanelHost/txtServerPort.text)
	
	# And create the server, using the function previously added into the code
	network.create_server()

func _on_ready_to_play():
	get_tree().change_scene("res://game_world.tscn")