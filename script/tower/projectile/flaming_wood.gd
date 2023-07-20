extends "res://script/tower/projectile/projectile.gd"


const EXPLODE_RADIUS: float = 128.0

var p0: Vector2
var p1: Vector2
var p2: Vector2
var t: float = 0.0


func _ready():
	super._ready()

	angular_velocity = 2 * randf() * PI
	if randf() < 0.5:
		angular_velocity *= -1

func die() -> void:
	$CollisionShape2D.shape = CircleShape2D.new()
	$CollisionShape2D.shape.radius = EXPLODE_RADIUS / 2
	explosion()
	game.shake_screen(3	)
	await get_tree().create_timer(0.05).timeout
	super.die()

func _process(delta):
	super._process(delta)

	t += delta

	var q0 = p0.lerp(p1, t)
	var q1 = p1.lerp(p2, t)

	var r = q0.lerp(q1, t)

	position = r

	if position.distance_squared_to(p2) < 10:
		die()


func target(target_pos: Vector2) -> void:
	# generate 3 points for the bezier curve
	p0 = position
	p1 = (position + target_pos) / 2 + Vector2(0, -100)
	p2 = target_pos

	queue_redraw()