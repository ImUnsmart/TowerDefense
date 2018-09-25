extends "res://scripts/tower/laser.gd"

var super = false
var chain = false
var chained = Array()

func init():
	fire_rate = 1.0
	damage = 1
	display_name = "Lightning"
	description = "Locks on and damages targets, metal coated targets take much more damage."
	upgrade_costs = [500, 800, 600, 1250, 8000]
	upgrade_names = ["Shocking", "Lightning Rod", "Ranged Shock", "Chain Shock", "SuperShock"]
	upgrade_descriptions = ["Deals 1 extra damage per tick.", "Shoots much faster.", "Can shock enemies that are much further away.", "Enemies that are shocked may shock other nearby enemies.", "Enemies with a metal coating instantly lose it."]
	start_radius = 48
	cost = 450
	value = cost
	color = Color(0, 1, 1)

func upgrade():
	value += upgrade_costs[level]
	level += 1
	if level == 1:
		damage += 1
	elif level == 2:
		fire_rate -= 0.3
	elif level == 3:
		inc_radius(32)
	elif level == 4:
		chain = true
	elif level == 5:
		super = true
	$shoot_timer.wait_time = fire_rate
	
func _process(delta):
	._process(delta)
	update()

func _on_shoot_timer_timeout():
	if target == null or !wr.get_ref():
		return
	target.hurt(damage)
	if chain:
		for enemy in game.get_node("spawner/enemies").get_children():
			if enemy.position.distance_to(target.position) < 64 && chained.size() < 10 && enemy != target:
				enemy.hurt(1)
				game.explosion(enemy.position, color)
				chained.push_front(enemy)

func _draw():
	if target != null:
		var p = 1 - ($shoot_timer.time_left / $shoot_timer.wait_time)
		draw_line(to_local(position), to_local(target.position), Color(color.r * p, color.g * p, color.b * p), thickness)
		for enemy in chained:
			draw_line(to_local(target.position), to_local(enemy.position), Color(color.r, color.g, color.b), thickness)
		chained.clear()