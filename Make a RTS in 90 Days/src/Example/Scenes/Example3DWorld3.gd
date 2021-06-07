extends Spatial


# 0 - Authority, 1 - Happiness, 2 - Wealth, 3 - Materials
var playerRez = [5, 100, 2000, 100]
var RezMax = [100, 350, 999999, 999999]
var RezMin = [0, 0, 0, 0]
onready var authTimer = $AuthorityRefresh


func _ready():
	happinessChange(playerRez[1])


func _on_AuthorityRefresh_timeout():
	resourceChange(1, 0)
#	print("ok")
	pass # Replace with function body.


func resourceChange(value, index):
	print(value)
	match index:
		0:
			var holdAuth = playerRez[0]
			holdAuth += value
			holdAuth = clamp(holdAuth, RezMin[0], RezMax[0])
			print(holdAuth)
			playerRez[0] = holdAuth


func happinessChange(value):
	var Bool = authTimer.is_stopped()
	if value > 0:
#		determine wait time
		if value == 100:
			authTimer.wait_time = 6
#		if Bool true then start
		if Bool:
			pass
		authTimer.start()
		pass
	else:
		authTimer.stop()
		authTimer.wait_time = 1200
	pass

func _input(event):
	var happiness = playerRez[1]
	var happinessCheck = happiness
	if event.is_action_pressed("add"):
		happiness += 5
	elif event.is_action_pressed("subtract"):
		happiness -= 5
	happiness = clamp(happiness, 0, 350)
	if happinessCheck != happiness:
		happinessChange(happiness)
	playerRez[1] = happiness
