extends Control

remotesync var players = {"carthage":0,"rome":0,"greece":0,"egypt":0,"persia":0}
var currentSelection = ""
var net = NetworkedMultiplayerENet.new()

var playersNum = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	Standard Signals for Multiplayer
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	SoundManager.play_bgm("res://Assets/Sound/Music/bensound-birthofahero.ogg")
	pass # Replace with function body.


func _on_QuitButton_pressed():
	net.close_connection(5)
	get_tree().quit()
	pass # Replace with function body.


func _on_HostButton_pressed():
	if not get_tree().is_network_server():
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.disabled = true
		var err = net.create_server(11111,16)
		print(err)
		get_tree().network_peer = net
		print(get_tree().get_network_peer())
		$MultiPanel/VSplitContainer/HBoxContainer/HostButton.text = "STOP"
		playersNum = 1
		update_player_count()
	else:
		net.close_connection()
		get_tree().network_peer = null
		print(get_tree().get_network_peer())
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.disabled = false
		$MultiPanel/VSplitContainer/HBoxContainer/HostButton.text = "HOST"
		for country in players:
			country = 0
		select_nation(currentSelection)
		playersNum = 0
		update_player_count()
	pass # Replace with function body.


func update_player_count():
	if playersNum == 0:
		$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/PlayerCount.text = ""
	else:
		$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/PlayerCount.text = str(playersNum)


func _on_PButton_pressed():
	if get_tree().network_peer:
		rpc("select_nation", "persia")
	select_nation("persia")


func _on_EButton_pressed():
	if get_tree().network_peer:
		rpc("select_nation", "egypt")
	else:
		select_nation("egypt")


func _on_GButton_pressed():
	if get_tree().network_peer:
		rpc("select_nation", "greece")
	else:
		select_nation("greece")


func _on_RButton_pressed():
	if get_tree().network_peer:
		rpc("select_nation", "rome")
	else:
		select_nation("rome")


func _on_CButton_pressed():
	if get_tree().network_peer:
		rpc("select_nation", "carthage")
	else:
		select_nation("carthage")


remotesync func select_nation(val:String):
	if currentSelection == val:
		return
	elif currentSelection != "":
		if players[currentSelection] > 0:
			players[currentSelection] -= 1
	players[val] += 1
	currentSelection = val
	update_numbers()
	

func update_numbers():
	for key in players.keys():
		if players.get(key) == 0:
			update_line_edit(key,"")
			pass
		else:
			update_line_edit(key,str(players.get(key)))
		pass
		

func update_line_edit(country:String, val:String):
	match country:
		"carthage":
			$PanelContainer4/VBoxContainer/NationsHBox/CarthageContainer/CarthageLineEdit.text = str(val)
			pass
		"rome":
			$PanelContainer4/VBoxContainer/NationsHBox/RomeContainer/RomeLineEdit.text = str(val)
			pass
		"greece":
			$PanelContainer4/VBoxContainer/NationsHBox/GreeceContainer/GreeceLineEdit.text = str(val)
			pass
		"egypt":
			$PanelContainer4/VBoxContainer/NationsHBox/EgyptContainer/EgyptLineEdit.text = str(val)
			pass
		"persia":
			$PanelContainer4/VBoxContainer/NationsHBox/PersiaContainer/PersiaLineEdit.text = str(val)
			pass


# Should Connect to the server at IPEdit and port 11111
func _on_JoinButton_pressed():
	if get_tree().get_network_peer():
		net.close_connection()
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.text = "JOIN"
	var err = net.create_client($MultiPanel/VSplitContainer/HBoxContainer/IPEdit.text,11111)
	print(err)
	if not err == OK:
		return
	get_tree().network_peer = net
	$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.text = "LEAVE"
	pass # Replace with function body.


func _on_TextureRect_mouse_entered():
	$PanelContainer4/VBoxContainer/HSplitContainer/TextureRect/AudioStreamPlayer2D.play() # Replace with function body.


func _player_connected():
	playersNum += 1
	update_player_count()
	pass
	

func _player_disconnected():
	playersNum -= 1
	update_player_count()
	pass
