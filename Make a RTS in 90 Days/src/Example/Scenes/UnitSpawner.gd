extends Area2D

export (PackedScene) var unit_type_1

func unit_spawner_clicked():
	var unit = unit_type_1.instance()
	#last part just adds randomness to spawner positions
	unit.global_position = global_position + Vector2(randi() % 100 + 32, randi() % 100 + 32)
	get_tree().root.add_child(unit)



func _on_UnitSpawner_input_event(viewport, event, shape_idx):
	if (event is InputEventMouseButton and event.pressed):
		unit_spawner_clicked()
