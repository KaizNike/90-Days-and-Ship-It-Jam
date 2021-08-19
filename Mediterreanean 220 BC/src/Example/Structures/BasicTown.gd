extends Area

onready var teamMesh = [$StaticBody/TeamRoof,$StaticBody2/TeamRoof,$StaticBody3/TeamRoof]
var meshes = ["res://src/Example/Units/RomeRed.tres", "res://src/Example/Units/EgyptBlue.tres", "res://src/Example/Units/CarthageYellow.tres", "res://src/Example/Units/GreeceGreen.tres"]

export var team = 0

func select():
	print("ok")
	$SelectionArrow.visible = true

func deselect():
	$SelectionArrow.visible = false

func _ready():
	for mesh in teamMesh:
		mesh.set_surface_material(0, load(meshes[team]))
