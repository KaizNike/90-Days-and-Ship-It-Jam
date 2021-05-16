extends Node

onready var sprite = $BlueEngie
onready var nav = $Navigation2D
onready var line = $Line2D

# https://www.youtube.com/watch?v=0fPOt0Jw52s

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
	if not sprite.selected:
		return
	var new_path = nav.get_simple_path(sprite.global_position, event.global_position)
	line.points = new_path
	sprite.path = new_path
	pass
