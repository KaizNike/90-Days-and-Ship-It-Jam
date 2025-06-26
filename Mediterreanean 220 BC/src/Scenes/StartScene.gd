extends Control

remotesync var players := {"carthage":[],"rome":[],"greece":[],"egypt":[],"persia":[]}
var connectedIds := []
var currentSelection := ""
var net := NetworkedMultiplayerENet.new()

remotesync var playersNum := 0
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
#	SoundManager.play_bgm("res://Assets/Sound/Music/bensound-birthofahero.ogg")
	pass # Replace with function body.


func _on_QuitButton_pressed():
	net.close_connection(5)
	get_tree().network_peer = null
	get_tree().quit()
	pass # Replace with function body.


func _on_HostButton_pressed():
	if not get_tree().is_network_server():
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.disabled = true
		var err = net.create_server(int($MultiPanel/VSplitContainer/HBoxContainer/PortEdit.text),int($MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text))
		print(err)
		get_tree().network_peer = net
		print(get_tree().get_network_peer())
		$MultiPanel/VSplitContainer/HBoxContainer/HostButton.text = "STOP"
		playersNum = 1
		update_player_count()
		print("ID: " + str(get_tree().get_network_unique_id()))
	else:
		net.close_connection()
		get_tree().network_peer = null
		print(get_tree().get_network_peer())
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.disabled = false
		$MultiPanel/VSplitContainer/HBoxContainer/HostButton.text = "HOST"
		for country in players:
			players[country].clear()
		select_nation(currentSelection,0)
		playersNum = 0
		update_player_count()
	pass # Replace with function body.


# Should Connect to the server at IPEdit and port 11111
func _on_JoinButton_pressed():
	if get_tree().get_network_peer() != null:
		net.close_connection()
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.text = "JOIN"
		get_tree().network_peer = null
		return
	var err = net.create_client($MultiPanel/VSplitContainer/HBoxContainer/IPEdit.text,int($MultiPanel/VSplitContainer/HBoxContainer/PortEdit.text)) #11111
	print(err)
	if not err == OK:
		return
	get_tree().network_peer = net
	$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.text = "LEAVE"
	pass # Replace with function body.


func update_player_count():
	if playersNum == 0:
		$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/PlayerCount.text = ""
	else:
		$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/PlayerCount.text = str(playersNum)


func _on_PButton_pressed():
	nation_select_pressed("persia")


func _on_EButton_pressed():
	nation_select_pressed("egypt")


func _on_GButton_pressed():
	nation_select_pressed("greece")


func _on_RButton_pressed():
	nation_select_pressed("rome")


func _on_CButton_pressed():
	nation_select_pressed("carthage")


func nation_select_pressed(nation:String):
	if get_tree().network_peer != null:
		if get_tree().network_peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED:
			rpc("select_nation", nation, get_tree().get_network_unique_id())
	else:
		select_nation(nation,0)
	currentSelection = nation


remotesync func select_nation(val:String, id: int):
	if currentSelection == val:
		update_numbers()
		return
	elif currentSelection != "" and currentSelection != null:
		if players[currentSelection].size() > 0:
			if get_tree().network_peer != null:
				var find = players[currentSelection].find(id)
				if not find == -1:
					players[currentSelection].remove(find)
			else:
				players[currentSelection].clear()
	players[val].append(id)
	update_numbers()
	return
	

func update_numbers():
	for key in players.keys():
		if players.get(key).size() == 0:
			update_line_edit(key,"")
			pass
		else:
			update_line_edit(key,str(players.get(key).size()))
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


func _on_TextureRect_mouse_entered():
	$PanelContainer4/VBoxContainer/HSplitContainer/TextureRect/AudioStreamPlayer2D.play() # Replace with function body.


func _player_connected(id):
	if get_tree().get_network_connected_peers().size() > int($MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text):
		net.disconnect_peer(id,true)
		return
	connectedIds.append(id)
	playersNum += 1
	update_player_count()
	pass
	

func _player_disconnected(id):
	var search = connectedIds.find(id)
	if search != -1:
		connectedIds.remove(search)
	playersNum -= 1
	update_player_count()
	pass
	
# remote or rpc, trying puppet
puppet func sync_data(countries:Dictionary,playersNumV:int):
	if countries.size() != 5:
		return
	for country in players:
		players[country].clear()
	playersNum = playersNumV
	players = countries.duplicate(true)
	pass


master func request_sync(id):
	if get_tree().get_network_connected_peers().size() > int($MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text):
		net.disconnect_peer(id,true)
		return
	rpc_id(id,"sync_data",players,playersNum)


func _connected_ok():
	print("ID: " + str(get_tree().get_network_unique_id()))
	rpc_id(1,"request_sync",get_tree().get_network_unique_id())
	pass


func _connected_fail():
	print("Didn't connect.")
	pass
	

func _server_disconnected():
	print("Server offline.")
	for country in players:
		players[country].clear()
	players[currentSelection].append(0)
	pass


func _on_LineEdit_text_changed(new_text):
	if int(new_text):
		if int(new_text) > 4095:
			$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text = str(4095)
		if int(new_text) < 1:
			$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text = str(1)
		$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text = str(int($MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text))
	else:
		$MultiPanel/VSplitContainer/HSplitContainer/HSplitContainer/LineEdit.text = str(16)
	pass # Replace with function body.
