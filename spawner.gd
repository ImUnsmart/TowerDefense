extends Node2D

const enemy = preload("res://scenes/enemy.tscn")
var path
var spawning = false
var enemys
var spawned
var e_index

func _ready():
	path = get_tree().root.get_node("Game/path/follow")
	pass

func _on_spawn_timer_timeout():
	var e
	if enemys[e_index][0] == 0:
		e = enemy.instance()
	e.position = Vector2(path.position.x + 16, path.position.y)
	e.path = path
	e.health = enemys[e_index][3]
	e.speed = enemys[e_index][4]
	e.damage = enemys[e_index][5]
	$enemies.add_child(e)
	spawned += 1
	if spawned >= enemys[e_index][1]:
		spawned = 0
		e_index += 1
		if e_index >= enemys.size():
			spawning = false
			$spawn_timer.stop()
		else:
			print(enemys[e_index][2])
			$spawn_timer.wait_time = enemys[e_index][2]
			
# [ type, count, delay, health, speed, damage ]=

func start(wave):
	spawning = true
	var e
	if wave == 1:
		e = [ [ 0, 10, 1, 1, 1, 1 ] ]
	if wave == 2:
		e = [ [ 0, 10, 0.5, 1, 1, 1 ], [0, 3, 2, 2, 1, 1] ]
	if wave == 3:
		e = [ [ 0, 3, 4, 3, 1, 1] ]
	enemys = e
	$spawn_timer.wait_time = e[0][2]
	$spawn_timer.start()
	e_index = 0
	spawned = 0