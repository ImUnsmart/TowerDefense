extends Node

var monster_data = {
	"slime": {
		"name": "Slime",
		"icon": "res://assets/slime.png",
		"icon_region": Rect2i(0, 0, 8, 8),
		"scene": preload("res://scenes/monster/slime.tscn"),
	},
	"zombie": {
		"name": "Zombie",
		"icon": "res://assets/zombie.png",
		"icon_region": Rect2i(0, 0, 8, 8),
		"scene": preload("res://scenes/monster/zombie.tscn"),
	},
	"bat": {
		"name": "Bat",
		"icon": "res://assets/bat.png",
		"icon_region": Rect2i(0, 0, 8, 8),
		"scene": preload("res://scenes/monster/bat.tscn"),
	},
	"gloop": {
		"name": "Gloop",
		"icon": "res://assets/gloop.png",
		"icon_region": Rect2i(0, 0, 8, 8),
		"scene": preload("res://scenes/monster/gloop.tscn"),
	},
	"skeleton": {
		"name": "Skeleton",
		"icon": "res://assets/skeleton.png",
		"icon_region": Rect2i(0, 0, 8, 8),
		"scene": preload("res://scenes/monster/skeleton.tscn"),
	}
}

func get_mname(monster: String) -> String:
	return monster_data[monster]["name"]

func get_description(monster: String) -> String:
	return monster_data[monster]["description"]

func get_icon(monster: String) -> Texture:
	var icon = AtlasTexture.new()
	icon.atlas = load(monster_data[monster]["icon"])
	icon.region = monster_data[monster]["icon_region"]
	return icon


func get_scene(monster: String) -> PackedScene:
	return monster_data[monster]["scene"]
