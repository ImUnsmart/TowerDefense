extends Node2D

@onready var inner = $ExplosionParticlesInner
@onready var outer = $ExplosionParticlesOuter
@onready var smoke = $ExplosionParticlesSmoke

func _ready():
	inner.emitting = true
	outer.emitting = true
	smoke.emitting = true

	inner.one_shot = true
	outer.one_shot = true
	smoke.one_shot = true


func _process(delta):
	pass


func _on_timer_timeout() -> void:
	call_deferred("queue_free")
