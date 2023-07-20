extends GPUParticles2D


func _ready():
	process_material = process_material.duplicate()
	one_shot = true
	await get_tree().create_timer(lifetime + 0.05).timeout
	call_deferred("queue_free")


func _process(delta):
	pass