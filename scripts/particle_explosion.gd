extends Particles2D

export(Color) var start
export(Color) var end

func _ready():
	one_shot = true
	get_process_material().get_color_ramp().gradient.colors[0] = start
	get_process_material().get_color_ramp().gradient.colors[1] = end
	
func set_colors(start, end):
	get_process_material().get_color_ramp().gradient.colors[0] = start
	get_process_material().get_color_ramp().gradient.colors[1] = end

func _process(delta):
	if !emitting:
		queue_free()