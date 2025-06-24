extends PanelContainer

var step = 0
var pretned = {2: false}
var stor = 0
var stor2 = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	if $Timer.wait_time > 1:
		$Timer.wait_time = 0.235
	match step:
		0:
			var n = (randi() % 102) + 2
			$LineEdit.text = "Sieve(" + str(n) + ")"
			step += 1
			stor = n
			return
		1:
			$LineEdit.text = "Primes:"
			stor = sieve(stor)
			step += 1
			return
		2:
			$LineEdit.text = show_next(stor)
			if $LineEdit.text == "":
				stor.clear()
				stor = 0
				step = 0
				return
			pass
	pass # Replace with function body.


func sieve(num):
	var A = {}
	for i in range(2,num):
		A[i] = true
	print(A)
	for i in range(2, sqrt(num-1)):
		if A[i] == true:
			for j in range(pow(i,2),num,i):
				A[j] = false
	print(A)
	return A

func show_next(dict:Dictionary) -> String:
	if dict.keys().size() > 0:
		for key in dict.keys():
			if dict[key] == true:
				dict.erase(key)
				return str(key)
			elif dict[key] == false:
				dict.erase(key)
				continue
	return ""
