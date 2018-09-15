extends "res://scripts/cannon.gd"

var damage = 1
var fire = false

func init():
	cost = 300
	fire_rate = 1.2
	display_name = "Laser"
	description = "Locks on and slowly damages targets."
	upgrade_costs = [100, 400, 1000, 3000, 10000]
	upgrade_names = ["Wider Detection", "Faster Heating", "Plasma", "Superheated", "Solar Power"]
	upgrade_descriptions = ["Increases range by 50%.", "Faster firing rate.", "Deals 1 extra damage per tick.", "Double speed firing and lights enemies on fire.", "Absorbs solar rays and incinerates enemies."]
	start_radius = 64

func upgrade():
	level += 1
	if level == 1:
		inc_radius(32)
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
		inc_radius(64)
	$shoot_timer.wait_time = fire_rate
	
func _process(delta):
	._process(delta)
	print($shoot_timer.wait_time)
	update()

func _on_shoot_timer_timeout():
	if target == null or !wr.get_ref():
		return
	target.hurt(damage)

func _draw():
	if target != null:
		var r = 1 - ($shoot_timer.time_left / $shoot_timer.wait_time)
		print($shoot_timer.time_left / $shoot_timer.wait_time)
		draw_line(to_local(position), to_local(target.position), Color(r, 0, 0), 1)
