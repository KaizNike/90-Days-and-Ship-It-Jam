extends KinematicBody

var path = []
var path_ind = 0
const move_speed = 6

onready var nav = get_parent()


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
			move_and_slide(move_vec.normalized() * move_speed, Vector3(0, 1, 0))

func select():
	$SelectionArrow.show()

func deselect():
	$SelectionArrow.hide()
