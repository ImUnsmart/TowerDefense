extends Area2D

func _ready():
	pass

func _on_base_area_entered(area):
	if "Enemy" in area.get_name():
		get_tree().root.get_node("Game").damage(area.damage)
		area.queue_free()

