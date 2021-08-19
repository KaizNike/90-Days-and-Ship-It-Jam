extends KinematicBody

var path = []
var path_ind = 0
# Teams - 0: Rome, 1: Egypt, 2: Carthage, 3: Greece
export var team = 0
const move_speed = 6
var meshes = ["res://src/Example/Units/RomeRed.tres", "res://src/Example/Units/EgyptBlue.tres", "res://src/Example/Units/CarthageYellow.tres", "res://src/Example/Units/GreeceGreen.tres"]

onready var nav = get_parent()
onready var body = $BodyMesh

func _ready():
	body.set_surface_material(0, load(meshes[team]))
	

func move_to(target_pos):
#	look_at(-target_pos, Vector3(0,1,0))
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_ind = 0

func _physics_process(delta):
	if path_ind < path.size():
		var move_vec = (path[path_ind] - global_transform.origin)
		if move_vec.length() < 0.1:
			path_ind += 1
		else:
			look_at(-move_vec + translation, Vector3.UP)
#			rotation = move_vec
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))

func select(group_num):
	$SelectionArrow.show()

func deselect():
	$SelectionArrow.hide()
