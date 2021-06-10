extends Node2D


# REF - Power: 1.0 = average human with rock, Health: Ability to survive damage, Armor Class: In this age it ranges from 0 to 20, ability to survive. (Lossing more than half in single attack should cripple), Stamina: Determines how long an endurance test can last, Encumbrance: Rate at which stamina is lost when tested, Range: Effective attack range in meters, Speed: Average run in km/h, Attack Speed: Attacks per second
const UNITS = {
	"human_basic": {"power": 1.0, "health": 10.0, "armor_class": 1, "stamina": 10.0, "encumbrance": 0.1, "range": 0.4, "speed": 32.0, "attack_speed": 1.0},
	"worker": {"power": 0.2, "health": 8.0, "armor_class": 2, "stamina": 30.0, "encumbrance": 1, "range": 0.4, "speed": 26.0, "attack_speed": 0.2},
	"ranged": {"power": 3.0, "health": 12.0, "armor_class": 4, "stamina": 48.0, "encumbrance": 1.4, "range": 60, "speed": 30.0, "attack_speed": 0.28},
	"light": {"power": 4.0, "health": 16.0, "armor_class": 6, "stamina": 60.0, "encumbrance": 1.2, "range": 1.1, "speed": 42.0, "attack_speed": 1.2},
	"heavy": {"power": 6.5, "health": 28.0, "armor_class": 16, "stamina": 144.0, "encumbrance": 6, "range": 0.6, "speed": 12.0, "attack_speed": 0.7},
	"boat": {"power": 96.0, "health": 148.0, "armor_class": 8, "stamina": 10.0, "encumbrance": 1.2, "range": 0.1, "speed": 112.0, "attack_speed": 0.1},
}

func _ready():
	print(UNITS.human_basic.power)
