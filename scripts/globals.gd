extends Node

#const game = get_tree().root.get_node("Game")
const explode = preload("res://scenes/particle_explosion.tscn")

static func explosion(position):
	var e = explode.instance()
	e.position = position
	get_tree().root.get_node("Game").add_child(e)
	return e