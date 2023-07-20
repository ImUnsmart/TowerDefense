extends "res://script/tower/projectile/projectile.gd"

var proj

@export var shrapnel_scene = preload("res://scenes/tower/projectile/shrapnel.tscn")

var shatter: int = 0

func _ready():
	super._ready()

	proj = game.get_node("Projectiles")

func hit_monster(monster: PathFollow2D) -> void:
	super.hit_monster(monster)

	for i in range(shatter):
		var shrapnel = shrapnel_scene.instantiate()
		shrapnel.position = position
		var angle = 2 * randf() * PI
		shrapnel.velocity = Vector2(cos(angle), sin(angle)) * shrapnel.speed
		shrapnel.hit[monster] = true
		proj.add_child(shrapnel)
