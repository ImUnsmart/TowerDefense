extends Area2D

var color = Color(0, 0, 0, 0.5)

func _process(delta):
	if is_visible_in_tree():
		if !get_parent().can_place:
			color = Color(0.5, 0, 0, 0.5)
		else:
			color = Color(0, 0, 0, 0.5)

func _draw():
	draw_circle(Vector2(0 ,0),$radius.shape.radius,color)