extends Area2D

func _ready():
	pass

func _on_base_body_entered(body):
	if "Enemy" in body.get_name():
		get_tree().root.get_node("Game").damage(body.damage)
		body.queue_free()