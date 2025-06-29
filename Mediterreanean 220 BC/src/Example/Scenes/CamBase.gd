extends Spatial

const MOVE_MARGIN = 20
const MOVE_SPEED = 30

const ray_length = 1000
const scroll_factor = 0.95
onready var cam = $Camera

export var team = 0
var selected_units = []
var selected_building = null
onready var selection_box = $SelectionBox
var start_sel_pos = Vector2()

func _ready():
	get_parent().get_node("UI/ViewportContainer").connect("move_camera", self, "on_minimap_clicked")

func _physics_process(delta):
	var m_pos = get_viewport().get_mouse_position()
	#the next line is for moving the camera when the mouse gets tothe edge of the screen
	calc_move(m_pos, delta)
#	if Input.is_action_just_pressed("alt_command"):
#		move_selected_units(m_pos)
	if Input.is_action_just_pressed("main_command"):
		selection_box.start_sel_pos = m_pos
		start_sel_pos = m_pos
	if Input.is_action_pressed("main_command"):
		selection_box.m_pos = m_pos
		selection_box.is_visible = true
	else:
		selection_box.is_visible = false
#	if Input.is_action_just_released("main_command"):
#		select_units(m_pos)
#		if not selected_units:
#			select_buildings(m_pos)

func _unhandled_input(event):
	var m_pos = get_viewport().get_mouse_position()
	if event.is_action_pressed("alt_command"):
		move_selected_units(m_pos)
#	if event.is_action_pressed("main_command") and selection_box.is_visible == false:
#		selection_box.start_sel_pos = m_pos
#		start_sel_pos = m_pos
#	if event.is_action_pressed("main_command"):
#		selection_box.m_pos = m_pos
#		selection_box.is_visible = true
#	else:
#		selection_box.is_visible = false
	if event.is_action_released("main_command"):
		select_units(m_pos)
		if not selected_units:
			select_buildings(m_pos)
	if event is InputEventMouseButton and event.is_pressed():
#			zoom in
		if event.button_index == BUTTON_WHEEL_UP:
			var fov = cam.fov
			fov -= scroll_factor
			fov = clamp(fov, 1, 180)
			cam.fov = fov
#			zoom out
		elif event.button_index == BUTTON_WHEEL_DOWN:
			var fov = cam.fov
			fov += scroll_factor
			fov = clamp(fov, 1, 180)
			cam.fov = fov
#		var m_pos = get_viewport().get_mouse_position()
		
			

func on_minimap_clicked(world_pos):
	print("OK")
	self.translation = Vector3(world_pos.x, self.translation.y, world_pos.z)
	print(translation)


func calc_move(m_pos, delta):
	var v_size = get_viewport().size
	var move_vec = Vector3()
	if m_pos.x < MOVE_MARGIN:
		move_vec.x -= 1
	if m_pos.y < MOVE_MARGIN:
		move_vec.z -= 1
	if m_pos.x > v_size.x - MOVE_MARGIN:
		move_vec.x += 1
	if m_pos.y > v_size.y - MOVE_MARGIN:
		move_vec.z += 1
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation_degrees.y)
	global_translate(move_vec * delta * MOVE_SPEED)

func move_selected_units(m_pos):
	var result = raycast_from_mouse(m_pos, 1)
	if result:
		for unit in selected_units:
			var auth = get_parent().playerRez[0]
			if auth > 0:
				get_parent().playerRez[0] -= 1
			else:
				return
#			unit.look_at(-result.position, Vector3.UP)
#			unit.rotation.y = (unit.global_transform.origin - result.position).y
			unit.move_to(result.position)

func select_units(m_pos):
	var new_selected_units = []
	if m_pos.distance_squared_to(start_sel_pos) < 16:
		var u = get_collider_under_mouse(m_pos)
		if u != null:
			if "team" in u:
				if u.team == team:
					if u.is_in_group("units"):
						new_selected_units.append(u)
	else:
		new_selected_units = get_units_in_box(start_sel_pos, m_pos)
	if new_selected_units.size() != 0:
		if selected_building:
			_deselect_building()
		for unit in selected_units:
			unit.deselect()
		var new_unit_index = 0
		for unit in new_selected_units:
			unit.select(new_unit_index)
			new_unit_index += 1
		selected_units = new_selected_units
	elif new_selected_units.size() == 0:
		for unit in selected_units:
			unit.deselect()
		selected_units.clear()
		
func select_buildings(m_pos):
	var new_selected_building = null
	var u = get_collider_under_mouse(m_pos)
	if u != null and u.is_in_group("buildings"):
		new_selected_building = u
		if selected_building == null:
			selected_building = new_selected_building
			selected_building.select()
		if new_selected_building == selected_building:
			return
		else:
			selected_building.deselect()
			selected_building = new_selected_building
			selected_building.select()
	else:
		if selected_building:
			_deselect_building()
	pass

func _deselect_building():
	selected_building.deselect()
	selected_building = null

func get_collider_under_mouse(m_pos):
	var result = raycast_from_mouse(m_pos, 2)
#	print(result)
	if result:
		return result.collider

func get_units_in_box(top_left, bot_right):
	if top_left.x > bot_right.x:
		var tmp = top_left.x
		top_left.x = bot_right.x
		bot_right.x = tmp
	if top_left.y > bot_right.y:
		var tmp = top_left.y
		top_left.y = bot_right.y
		bot_right.y = tmp
	var box = Rect2(top_left, bot_right - top_left)
	var box_selected_units = []
	for unit in get_tree().get_nodes_in_group("units"):
		if unit and box.has_point(cam.unproject_position(unit.global_transform.origin)):
			if "team" in unit:
				if unit.team == team:
					box_selected_units.append(unit)
	return box_selected_units

func raycast_from_mouse(m_pos, collision_mask):
	var ray_start = cam.project_ray_origin(m_pos)
	var ray_end = ray_start + cam.project_ray_normal(m_pos) * ray_length
	var space_state = get_world().direct_space_state
	return space_state.intersect_ray(ray_start, ray_end, [], collision_mask, true, true)
