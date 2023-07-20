extends Node

var waves = {
	1: [
		{
			"type": "slime",
			"count": 5,
			"spacing": 0.8,
			"delay": 0,
		}
	],
	2: [
		{
			"type": "slime",
			"count": 10,
			"spacing": 0.8,
			"delay": 0,
		}
	],
	3: [
		{
			"type": "slime",
			"count": 5,
			"spacing": 0.5,
			"delay": 0,
		},
		{
			"type": "zombie",
			"count": 1,
			"spacing": 1.0,
			"delay": 2.5,
		}
	],
	4: [
		{
			"type": "zombie",
			"count": 3,
			"spacing": 1.0,
			"delay": 0,
		},
		{
			"type": "slime",
			"count": 5,
			"spacing": 0.7,
			"delay": 3.0,
		}
	],
	5: [
		{
			"type": "zombie",
			"count": 7,
			"spacing": 0.8,
			"delay": 0,
		},
	],
	6: [
		{
			"type": "slime",
			"count": 10,
			"spacing": 0.5,
			"delay": 0,
		},
		{
			"type": "zombie",
			"count": 3,
			"spacing": 1.2,
			"delay": 3.0,
		}
	],
	7: [
		{
			"type": "zombie",
			"count": 10,
			"spacing": 0.7,
			"delay": 0,
		},
	],
	8: [
		{
			"type": "slime",
			"count": 20,
			"spacing": 0.3,
			"delay": 0,
		}
	],
	9: [
		{
			"type": "zombie",
			"count": 10,
			"spacing": 0.7,
			"delay": 0,
		},
		{
			"type": "slime",
			"count": 10,
			"spacing": 0.3,
			"delay": 7.0,
		},
	],
	10: [
		{
			"type": "bat",
			"count": 5,
			"spacing": 1.0,
			"delay": 0,
		},
	],
	11: [
		{
			"type": "bat",
			"count": 10,
			"spacing": 0.8,
			"delay": 0,
		},
	],
	12: [
		{
			"type": "zombie",
			"count": 3,
			"spacing": 0.5,
			"delay": 0,
		},
		{
			"type": "slime",
			"count": 10,
			"spacing": 0.5,
			"delay": 1.0,
		},
		{
			"type": "bat",
			"count": 3,
			"spacing": 1.0,
			"delay": 1.5,
		},
	],
	13: [
		{
			"type": "zombie",
			"count": 5,
			"spacing": 0.5,
			"delay": 0,
		},
		{
			"type": "slime",
			"count": 15,
			"spacing": 0.5,
			"delay": 1.0,
		},
		{
			"type": "bat",
			"count": 4,
			"spacing": 1.0,
			"delay": 1.5,
		},
	],
	14: [
		{
			"type": "bat",
			"count": 10,
			"spacing": 0.3,
			"delay": 0,
		},
	],
	15: [
		{
			"type": "gloop",
			"count": 1,
			"spacing": 0.0,
			"delay": 0
		}
	],
	16: [
		{
			"type": "slime",
			"count": 30,
			"spacing": 0.3,
			"delay": 0,
		},
		{
			"type": "bat",
			"count": 10,
			"spacing": 0.8,
			"delay": 0,
		},
	],
	17: [
		{
			"type": "zombie",
			"count": 15,
			"spacing": 0.5,
			"delay": 0,
		},
		{
			"type": "slime",
			"count": 25,
			"spacing": 0.5,
			"delay": 1.0,
		},
		{
			"type": "bat",
			"count": 8,
			"spacing": 1.0,
			"delay": 1.5,
		},
	],
	18: [
		{
			"type": "bat",
			"count": 15,
			"spacing": 0.5,
			"delay": 0,
		},
		{
			"type": "skeleton",
			"count": 5,
			"spacing": 0.8,
			"delay": 7.5,
		},
	],
	19: [
		{
			"type": "slime",
			"count": 10,
			"spacing": 1.0,
			"delay": 0,
		},
		{
			"type": "zombie",
			"count": 10,
			"spacing": 1.0,
			"delay": 0,
		},
		{
			"type": "skeleton",
			"count": 8,
			"spacing": 0.8,
			"delay": 5.0,
		},
	],
	20: [
		{
			"type": "zombie",
			"count": 25,
			"spacing": 0.4,
			"delay": 0,
		},
		{
			"type": "skeleton",
			"count": 10,
			"spacing": 0.6,
			"delay": 5.0,
		},
	]
}

@onready var game = get_tree().root.get_node("Game")

var wave: int = 1
var spawning: bool = false

func _ready():
	pass

func spawn_enemy(enemy: Dictionary) -> void:
	var timer = Timer.new()
	add_child(timer)
	
	await get_tree().create_timer(enemy["delay"]).timeout

	timer.start(enemy["spacing"])

	var count = [0]
	
	timer.timeout.connect((func () -> void:
		count[0] += 1

		game.spawn_monster(MonsterData.get_scene(enemy["type"]))
		
		if count[0] >= enemy["count"]:
			timer.stop()
			timer.queue_free()
	))
	

func next_wave() -> void:
	if not spawning:
		spawning = true

	wave += 1
	game.wave_counter.text = "[img=24]%s[/img] %s" % [game.wave_sprite, wave]

	if not wave in waves:
		return
	
	for enemy in waves[wave]:
		spawn_enemy(enemy)
	

func _process(delta):
	if spawning and get_child_count() == 0 and game.get_node("MonsterPath").get_child_count() == 0:
		next_wave()
