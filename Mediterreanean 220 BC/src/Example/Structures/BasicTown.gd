extends StaticBody

func select():
	print("ok")
	$SelectionArrow.visible = true

func deselect():
	$SelectionArrow.visible = false
