extends Node2D

const enemy_basic = preload("res://scenes/enemy/enemy.tscn")
const enemy_blue = preload("res://scenes/enemy/enemy_blue.tscn")
var path
var spawning = false
var spawned = 0
var timer = 0
var done = true
var game

enum enemy {
    # Basic are the simplest enemies available and can be attacked by anything
    BASIC,
    # Blue are only able to be attacked by beams -- first appear wave 10
    BLUE
    # Green are only able to be attacked by projectiles
    #GREEN
}

const enemyInfo = {
	"BASIC":{"FIRST_ROUND":1,"STAT_MULTIPLIERS":{"HEALTH":1,"SPEED":100,"DAMAGE":1},"INTRODUCE":false},
	"BLUE":{"FIRST_ROUND":10,"STAT_MULTIPLIERS":{"HEALTH":1.5,"SPEED":100,"DAMAGE":1},"INTRODUCE":true,"INTRO":["Blue Enemies", "Blue Enemies are have more health and are immune to projectiles."]}
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
	waves()
	if !spawning && $enemies.get_child_count() == 0 && !done:
		game.wave_money()
		done = true
		for type in enemy.keys():
			if enemyInfo[type]["FIRST_ROUND"] - 1 == game.wave && enemyInfo[type]["INTRODUCE"]:
				game.show_dialog(enemyInfo[type]["INTRO"][0],enemyInfo[type]["INTRO"][1])

func spawn_enemy(type, health, speed, damage):
	var e
	if type == enemy.BASIC:
		e = enemy_basic.instance()
	if type == enemy.BLUE:
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
	if spawning:
		if wave == 1:
			if timer % 50 == 0:
				spawn_enemy(enemy.BASIC, 1, 75, 1)
			if spawned == 10:
				spawning = false
		if wave == 2:
			if timer % 25 == 0:
				spawn_enemy(enemy.BASIC, 1, 75, 1)
			if spawned == 15:
				spawning = false
		if wave == 3:
			if timer % 50 == 0:
				spawn_enemy(enemy.BASIC, 1, 150, 1)
			if spawned == 20:
				spawning = false
		if wave == 4:
			if timer % 60 == 0:
				spawn_enemy(enemy.BASIC, 2, 75, 1)
			if spawned == 10:
				spawning = false
		if wave == 5:
			spawn_enemy(enemy.BASIC, 8, 75, 1)
			spawning = false
		if wave == 6:
			if timer % 60 == 0:
				spawn_enemy(enemy.BASIC, 2, 150, 1)
			if spawned == 15:
				spawning = false
		if wave == 7:
			if timer % 10 == 0:
				spawn_enemy(enemy.BASIC, 1, 75, 1)
			if spawned == 25:
				spawning = false
		if wave == 8:
			if timer % 100 == 0:
				spawn_enemy(enemy.BASIC, 6, 75, 1)
			if spawned == 5:
				spawning = false
		if wave == 9:
			if timer % 125 == 0:
				spawn_enemy(enemy.BASIC, 5, 150, 1)
			if spawned == 10:
				spawning = false
		if wave == 10:
			spawn_enemy(enemy.BLUE, 10, 75, 2)
			spawning = false
		if wave == 11:
			if timer % 125 == 0:
				spawn_enemy(enemy.BASIC, 6, 75, 1)
			if timer % 50 == 0:
				spawn_enemy(enemy.BASIC, 3, 150, 1)
			if spawned == 30:
				spawning = false
		if wave == 12:
			if timer % 50 == 0:
				spawn_enemy(enemy.BASIC, 5, 75, 1)
				spawn_enemy(enemy.BASIC, 3, 75, 1)
			if spawned >= 35:
				spawning = false
		if wave == 13:
			print(spawning)
			if spawned <= 20:
				if timer % 25 == 0:
					spawn_enemy(enemy.BASIC, 5, 75, 1)
			elif spawned <= 23:
				if timer % 50 == 0:
					spawn_enemy(enemy.BLUE, 11, 75, 2)

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