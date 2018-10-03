extends "res://scripts/tower/cannon.gd"

var flame = false

func _ready():
	._ready()
	$shoot_timer.wait_time = fire_rate

func init():
	bullet_health = 1
	fire_rate = 0.55
	display_name = "Flamethrower"
	description = "Blasts fire at enemies very quickly."
	upgrade_costs = [500, 1000, 1500, 3000, 25000]
	upgrade_names = ["Further Reach", "Heating Up", "Superhot", "Fire Storm", "Inferno"]
	upgrade_descriptions = ["Longer range fireball action.", "Fire rate reduced significantly", "Fireballs can pierce 2 enemies instead of 1.", "Fireballs have a 50% chance to light enemies on fire.", "Non-stop fireball stream."]
	start_radius = 64
	cost = 900
	value = cost
	
func _process(delta):
	._process(delta)

func upgrade():
	value += upgrade_costs[level]
	level += 1
	if level == 1:
		inc_radius(32)
	elif level == 2:
		fire_rate = 0.325
	elif level == 3:
		bullet_health = 2
	elif level == 4:
		flame = true
	elif level == 5:
		fire_rate = 0.15
		inc_radius(16)
	$shoot_timer.wait_time = fire_rate

func _on_shoot_timer_timeout():
	if target == null or !wr.get_ref():
		return
	var b = bullet.instance()
	b.position = position
	var dir = Vector2(target.position.x - b.position.x, target.position.y - b.position.y).normalized()
	b.velocity = dir
	b.health = bullet_health
	$bullets.add_child(b)