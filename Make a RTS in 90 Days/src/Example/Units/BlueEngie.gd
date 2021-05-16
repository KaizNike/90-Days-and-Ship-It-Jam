extends KinematicBody2D

# https://www.youtube.com/watch?v=0fPOt0Jw52s

var speed = 400.0
var path = PoolVector2Array() setget set_path
var selected = false setget set_selected

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)
	

func _process(delta):
	if !selected:
		return
	var move_distance = speed * delta
	move_along_path(move_distance)
	pass
	
func move_along_path(distance : float):
	var start_point = position
	for i in range(path.size()):
		var distance_to_next = start_point.distance_to(path[0])
		if distance <= distance_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance/ distance_to_next)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(true)
		distance -= distance_to_next
		start_point = path[0]
		path.remove(0)
	
func set_path(value : PoolVector2Array):
	path = value
	if value.size() == 0:
		return
	set_process(true)
	pass

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
#		selected = true
		set_selected(true)
		
func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and selected:
		set_selected(false)


func set_selected(value : bool):
	print("selection changed")
	selected = value
	if value:
		GlobalSignals.emit_signal("selected_unit", get_path())
#		set_process(true)
		$AnimationPlayer.play("selected")
	else:
		$AnimationPlayer.play("unselected")
		set_path(PoolVector2Array())
	pass
