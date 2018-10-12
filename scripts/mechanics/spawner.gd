extends Node2D

const enemy_basic = preload("res://scenes/enemy/enemy.tscn")
const enemy_blue = preload("res://scenes/enemy/enemy_blue.tscn")
var path
var spawning = false
var spawned = 0
var timer = 0
var done = true
var index = 0
var delay = 1
var data
var game

enum enemy {
    # Basic are the simplest enemies available and can be attacked by anything
    basic,
    # Blue are only able to be attacked by beams -- first appear wave 10
    blue
    # Green are only able to be attacked by projectiles
    #GREEN
}

const enemyInfo = {
	"basic":{"FIRST_ROUND":1,"STAT_MULTIPLIERS":{"HEALTH":1,"SPEED":100,"DAMAGE":1},"INTRODUCE":false},
	"blue":{"FIRST_ROUND":10,"STAT_MULTIPLIERS":{"HEALTH":1.5,"SPEED":100,"DAMAGE":1},"INTRODUCE":true,"INTRO":["Blue Enemies", "Blue Enemies are have more health and are immune to projectiles."]}
}

enum subType {
	NORMAL,
	SPEEDY,
	TANKY
}

const enemySubtypesInfo = {
	"NORMAL":{"HEALTH":1,"SPEED":1,"DAMAGE":1},
	"SPEEDY":{"HEALTH":0.5,"SPEED":2,"DAMAGE":1},
	"TANKY":{"HEALTH":3,"SPEED":0.5,"DAMAGE":1}
}

enum gap_type {
	EXTRA_LARGE = 125,
	LARGE = 100,
	MEDIUM = 50,
	SMALL = 25,
	EXTRA_SMALL = 10
}

func _ready():
	game = get_tree().root.get_node("Game")
	path = game.get_node("path/follow")
	var file = File.new()
	file.open("res://data/waves.json", File.READ)
	var text = file.get_as_text()
	file.close()
	var parse = JSON.parse(text)
	data = parse.result
	pass

#func _on_spawn_timer_timeout():
#	var e
#	if enemys[e_index][0] == 0:
#		e = enemy.instance()
#	e.position = Vector2(path.position.x, path.position.y)
#	e.path = path
#	e.health = enemys[e_index][3]
#	e.speed = enemys[e_index][4]
#	e.damage = enemys[e_index][5]
#	$enemies.add_child(e)
#	spawned += 1
#	$spawn_timer.wait_time = enemys[e_index][2]
#	if spawned >= enemys[e_index][1]:
#		spawned = 0
#		e_index += 1
#		if e_index >= enemys.size():
#			spawning = false
#			$spawn_timer.stop()
#		else:
#			$spawn_timer.wait_time = enemys[e_index][2]
#

func _process(delta):
	if spawning:
		timer += 1
		print(timer)
	waves()
	if !spawning && $enemies.get_child_count() == 0 && !done:
		game.wave_money()
		done = true
		for type in enemy.keys():
			if enemyInfo[type]["FIRST_ROUND"] - 1 == game.wave && enemyInfo[type]["INTRODUCE"]:
				game.show_dialog(enemyInfo[type]["INTRO"][0],enemyInfo[type]["INTRO"][1])

func spawn_enemy(type, health, speed, damage):
	var e
	if type == enemy.basic:
		e = enemy_basic.instance()
	if type == enemy.blue:
		e = enemy_blue.instance()
	e.position = Vector2(-32, -32)
	e.path = path
	e.health = health
	e.speed = speed
	e.damage = damage
	$enemies.add_child(e)
	spawned += 1
	
func start():
	spawning = true
	spawned = 0
	done = false
	
## [ type, count, delay, health, speed, damage ]=
	
func waves():
	var wave = game.wave
	if wave == 0:
		return
	var enemies = data[String(wave)]["enemies"]
	if index < enemies.size():
		if timer % delay == 0:
			var data = enemies[index]
			delay = int(data.spacing)
			if spawned < int(data.amount):
				spawn_enemy(enemy[data.type], int(data.health), int(data.speed), 1)
			else:
				index += 1
				spawned = 0
				delay = 20
	else:
		spawning = false

#func start(wave):
#	spawning = true
#	var e
#	if wave == 1:
#		e = [ [ 0, 10, 1, 1, 1, 1 ] ]
#	if wave == 2:
#		e = [ [ 0, 10, 0.5, 1, 1, 1 ], [0, 3, 2, 2, 1, 1] ]
#	if wave == 3:
#		e = [ [ 0, 3, 4, 3, 1, 1] ]
#	enemys = e
#	$spawn_timer.wait_time = 0
#	$spawn_timer.start()
#	e_index = 0
#	spawned = 0