extends Node

var towers: Dictionary = {
	"bow":
	{
        "texture": preload("res://assets/bow.png"),
        "scene": preload("res://scenes/tower/tower_bow.tscn"),
		"name": "Bow",
		"description": "A basic tower that shoots arrows at enemies.",
		"cost": 10,
		"levels":
		[
			{
				"damage": 1,
				"range": 96,
				"fire_rate": 0.9,
				"proj_speed": 175,
				"proj_hitpoints": 1,
				"lookahead": 15.0,
				"cost": 0,
			},
            {
				"name": "Long Bow",
				"desc": "Increases sight range.",
				"damage": 1,
				"range": 128,
				"fire_rate": 0.9,
				"proj_speed": 175,
				"proj_hitpoints": 1,
				"lookahead": 15.0,
				"cost": 8
            },
            {
				"name": "Powerful Shots",
				"desc": "Increases arrow damage.",
				"damage": 2,
				"range": 128,
				"fire_rate": 0.9,
				"proj_speed": 175,
				"proj_hitpoints": 1,
				"lookahead": 15.0,
				"cost": 20
            },
            {
				"name": "Fast Firing",
				"desc": "Shoots much quicker.",
				"damage": 2,
				"range": 128,
				"fire_rate": 0.6,
				"proj_speed": 190,
				"proj_hitpoints": 1,
				"lookahead": 15.0,
				"cost": 25
            },
            {
				"name": "Magical Bow",
				"desc": "Fires bursts of arrows instead of one.",
				"damage": 2,
				"range": 160,
				"fire_rate": 0.7,
				"num_projectiles": 3,
				"projectile_spread": PI / 12,
				"proj_speed": 200,
				"proj_hitpoints": 1,
				"lookahead": 15.0,
				"cost": 75
            },
		]
	},
	"cannon": {
	    "texture": preload("res://assets/cannon.png"),
	    "scene": preload("res://scenes/tower/tower_cannon.tscn"),
	    "name": "Cannon",
	    "description": "Shoots powerful cannonballs that pierce up to 3 enemies.",
	    "cost": 25,
		"levels": [
			{
				"damage": 1,
				"range": 128,
				"fire_rate": 1.8,
				"proj_speed": 350,
				"proj_hitpoints": 3,
				"lookahead": 15.0,
				"hit_effect_color": Color(0, 0, 0, 1),
				"cost": 0
			},
			{
				"name": "Powerful Cannonballs",
				"desc": "Cannonballs can now pierce up to 5 enemies.",
				"damage": 1,
				"range": 128,
				"fire_rate": 1.8,
				"proj_speed": 350,
				"proj_hitpoints": 5,
				"lookahead": 15.0,
				"hit_effect_color": Color(0, 0, 0, 1),
				"cost": 15
			},
			{
				"name": "More Gunpowder",
				"desc": "Cannonballs deal 1 more damage and fly faster.",
				"damage": 2,
				"range": 128,
				"fire_rate": 1.9,
				"proj_speed": 400,
				"proj_hitpoints": 5,
				"lookahead": 12.0,
				"hit_effect_color": Color(0, 0, 0, 1),
				"cost": 20
			},
			{
				"name": "Shatter",
				"desc": "Cannonballs release shrapnel on impact, dealing damage to nearby enemies.",
				"damage": 2,
				"range": 128,
				"fire_rate":1.9,
				"proj_speed": 400,
				"proj_hitpoints": 5,
				"shatter": 3,
				"lookahead": 12.0,
				"hit_effect_color": Color(0, 0, 0, 1),
				"cost": 40
			},
			{
				"name": "The Big One",
				"desc": "One big bad cannonball.",
				"damage": 5,
				"range": 128,
				"fire_rate": 2.1,
				"proj_speed": 425,
				"proj_hitpoints": 8,
				"shatter": 5,
				"proj_scale": 2,
				"lookahead": 11.5,
				"hit_effect_color": Color(0, 0, 0, 1),
				"cost": 150
			},
		]
	},
	# "trebuchet": {
	#     "name": "Trebuchet",
	#     "description": "Launches incindiary projectiles that explode on impact, dealing group damage.",
	#     "cost": 100,
	#     "damage": 2,
	#     "range": 192,
	#     "fire_rate": 2.2,
	#     "proj_speed": 350,
	#     "proj_hitpoints": 9e9,
	#     "lookahead": 42.0,
	#     "texture": preload("res://assets/trebuchet.png"),
	#     "scene": preload("res://scenes/tower/tower_trebuchet.tscn")
	# },
}


func get_tower_data(tower_name: String) -> Dictionary:
	return towers[tower_name]
