extends AudioStreamPlayer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

var start = false

func _process(delta):
	if !playing && start:
		queue_free()

func start():
	play()
	start = true