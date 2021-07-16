extends PanelContainer

func _process(delta):
	var parent = get_parent().get_parent()
	var rez = parent.playerRez
	$HBoxContainer/ALab.text = "Authority: " + str(rez[0])
	$HBoxContainer/HLab.text = "Happiness: " + str(rez[1]) + "%"
	$HBoxContainer/WLab.text = "Wealth: " + str(rez[2])
	$HBoxContainer/MLab.text = "Materials: " + str(rez[3])
