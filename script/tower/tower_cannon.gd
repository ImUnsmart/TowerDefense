extends "res://script/tower/tower.gd"

@export var proj_scene = preload("res://scenes/tower/projectile/cannonball.tscn")

@onready var shoot_timer = $ShootTimer

var damage: int = 0
var fire_rate: float = 0.0
var range_: float = 0.0
var proj_speed: float = 0.0
var proj_hitpoints: int = 0
var proj_scale: float = 1.0
var hit_effect_color: Color = Color(0, 0, 0, 0)
var lookahead: float = 0.0
var shatter: int = 0

func _ready():
	tower_name = "cannon"
	super._ready()

	shoot_timer.start(fire_rate)

func upgrade() -> void:
	super.upgrade()
	var data = Towers.get_tower_data(tower_name).levels[level - 1]
	damage = data["damage"]
	fire_rate = data["fire_rate"]
	range_ = data["range"]
	proj_speed = data["proj_speed"]
	proj_hitpoints = data["proj_hitpoints"]
	lookahead = data["lookahead"]

	if "shatter" in data:
		shatter = data["shatter"]
	if "hit_effect_color" in data:
		hit_effect_color = data["hit_effect_color"]
	if "proj_scale" in data:
		proj_scale = data["proj_scale"]

	detection_shape.shape.radius = range_

	if level >= 3:
		hit_effect_color = Color(0.4, 0.2, 0.1, 1.0)

	sprite.play(str(level))


func _process(delta) -> void:
	super._process(delta)

	if placing:
		return

	# for targeting
	find_target()

	shoot_timer.paused = target == null or weakref(target).get_ref() == null


func _physics_process(delta) -> void:
	super._physics_process(delta)
	
	if placing:
		return
	# for targeting
	
	look_at_target(delta, lookahead)


func _on_shoot_timer_timeout() -> void:
	if placing:
		return
	
	if target == null or weakref(target).get_ref() == null:
		return

	if shoot_timer.wait_time != fire_rate:
		shoot_timer.stop()
		shoot_timer.start(fire_rate)
	
	var proj = proj_scene.instantiate()
	game.get_node("Projectiles").add_child(proj)
	proj.position = position
	proj.damage = damage
	proj.speed = proj_speed
	proj.hitpoints = proj_hitpoints
	proj.hit_effect_color = hit_effect_color
	proj.scale = Vector2(proj_scale, proj_scale)
	proj.shatter = shatter
	proj.target(lookahead_position)
