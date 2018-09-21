extends Area2D

export var damage = 1
export var health = 1
var velocity = 0

func _ready():
	pass
	
func _process(delta):
	position += velocity * 10
	if health < 1:
		queue_free()

func _on_timeout_timeout():
	queue_free()