extends "res://script/tower/tower.gd"

@export var proj_scene = preload("res://scenes/tower/projectile/arrow.tscn")

@onready var shoot_timer = $ShootTimer

var damage: int = 0
var fire_rate: float = 0.0
var range_: float = 0.0
var proj_speed: float = 0.0
var proj_hitpoints: int = 0
var hit_effect_color: Color = Color(0, 0, 0, 0)
var lookahead: float = 0.0
var num_projectiles: int = 1
var projectile_spread: float = 0.0

func _ready():
	tower_name = "bow"
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

	if "num_projectiles" in data:
		num_projectiles = data["num_projectiles"]
	if "projectile_spread" in data:
		projectile_spread = data["projectile_spread"]

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
	
	for i in range(num_projectiles):
		var proj = proj_scene.instantiate()
		game.get_node("Projectiles").add_child(proj)
		proj.position = position
		proj.damage = damage
		proj.speed = proj_speed
		proj.hitpoints = proj_hitpoints
		proj.hit_effect_color = hit_effect_color
		if num_projectiles > 1:
			proj.target_offset(lookahead_position, randf_range(-projectile_spread, projectile_spread))
		else:
			proj.target(lookahead_position)
