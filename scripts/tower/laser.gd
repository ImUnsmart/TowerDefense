extends "res://scripts/tower/cannon.gd"

var damage = 1
var fire = false
var color = Color(1, 0, 0)
var thickness = 1

func init():
	fire_rate = 1.0
	display_name = "Laser"
	description = "Locks on and slowly damages targets."
	upgrade_costs = [100, 400, 1000, 3000, 10000]
	upgrade_names = ["Wider Detection", "Faster Heating", "Plasma", "Superheated", "Solar Rays"]
	upgrade_descriptions = ["Increases range by 50%.", "Faster firing rate.", "Deals 1 extra damage per tick.", "Double damage beam and lights enemies on fire.", "Absorbs solar rays and incinerates enemies."]
	start_radius = 48
	cost = 300
	value = cost

func upgrade():
	value += upgrade_costs[level]
	level += 1
	if level == 1:
		inc_radius(16)
	elif level == 2:
		fire_rate -= 0.2
	elif level == 3:
		damage += 1
	elif level == 4:
		damage += 2
		fire = true
	elif level == 5:
		fire_rate /= 2
		damage += 3
		inc_radius(32)
		color = Color(1, 1, 0)
		thickness = 2
	$shoot_timer.wait_time = fire_rate
	
func _process(delta):
	._process(delta)
	update()

func _on_shoot_timer_timeout():
	if target == null or !wr.get_ref():
		return
	target.hurt(damage)
	if fire:
		target.dot(1, 2)

func _draw():
	if target != null:
		var p = 1 - ($shoot_timer.time_left / $shoot_timer.wait_time)
		draw_line(to_local(position), to_local(target.position), Color(color.r * p, color.g * p, color.b * p), thickness)
		
func get_cost():
	return cost