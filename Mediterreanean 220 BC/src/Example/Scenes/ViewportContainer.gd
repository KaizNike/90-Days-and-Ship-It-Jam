extends ViewportContainer

signal move_camera(world_pos)

func _gui_input(event):
	if event.is_pressed():
		if event.is_action_pressed("main_command"):
			var m_pos = get_local_mouse_position()
			print(m_pos)
			if not m_pos:
				return
			var loc = $Viewport/Camera.project_position(m_pos, 150)
			print(loc)
			emit_signal("move_camera", loc)
