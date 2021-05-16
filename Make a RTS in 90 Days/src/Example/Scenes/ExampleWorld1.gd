extends Node

var target = null

onready var sprite = $BlueEngie
onready var nav = $Navigation2D
onready var line = $Line2D

# https://www.youtube.com/watch?v=0fPOt0Jw52s

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalSignals.connect("selected_unit", self, "set_selected_unit")

func set_selected_unit(unit_id):
	print(unit_id)
	target = get_node(unit_id)

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
	if not target.selected:
		return
	var new_path = nav.get_simple_path(target.global_position, event.global_position)
	line.points = new_path
	target.path = new_path
	pass
