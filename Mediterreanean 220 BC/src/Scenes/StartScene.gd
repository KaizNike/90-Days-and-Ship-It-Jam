extends Control

var players = {"carthage":0,"rome":0,"greece":0,"egypt":0,"persia":0}
var currentSelection = ""
var net = NetworkedMultiplayerENet.new()
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
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
		net.server_relay = false
		get_tree().network_peer = net
		print(get_tree().get_network_peer())
		$MultiPanel/VSplitContainer/HBoxContainer/HostButton.text = "STOP"
	else:
		net.close_connection()
		print(get_tree().get_network_peer())
		$MultiPanel/VSplitContainer/HBoxContainer/JoinButton.disabled = false
		$MultiPanel/VSplitContainer/HBoxContainer/HostButton.text = "HOST"
	pass # Replace with function body.



func _on_PButton_pressed():
	select_nation("persia")


func _on_EButton_pressed():
	select_nation("egypt")


func _on_GButton_pressed():
	select_nation("greece")


func _on_RButton_pressed():
	select_nation("rome")


func _on_CButton_pressed():
	select_nation("carthage")


func select_nation(val:String):
	if currentSelection == val:
		return
	elif currentSelection != "":
		players[currentSelection] -= 1
	players[val] += 1
	currentSelection = val
	update_numbers()
	

func update_numbers():
	var val = ""
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


func _on_JoinButton_pressed():
	pass # Replace with function body.


func _on_TextureRect_mouse_entered():
	$PanelContainer4/VBoxContainer/HSplitContainer/TextureRect/AudioStreamPlayer2D.play() # Replace with function body.
