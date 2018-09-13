extends Node2D

const enemy = preload("res://scenes/enemy.tscn")
var path

func _ready():
	$spawn_timer.wait_time = 10
	path = get_tree().root.get_node("Game/path/follow")
	pass

func _on_spawn_timer_timeout():
	var e = enemy.instance()
	e.position = Vector2(path.position.x + 16, path.position.y)
	e.path = path
	$enemies.add_child(e)
	$spawn_timer.wait_time -= 0.25
