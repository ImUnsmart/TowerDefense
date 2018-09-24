extends "res://scripts/tower/tower.gd"

var bullet = preload("res://scenes/tower/cannonball.tscn")
var bullet_health

func _ready():
	._ready()
	$shoot_timer.wait_time = fire_rate

func init():
	bullet_health = 2
	display_name = "Cannon"
	description = "Shoots slow cannonballs that hit multiple enemies."
	upgrade_costs = [250, 500, 1000, 4000, 25000]
	upgrade_names = ["Longer Range", "Bigger Cannonballs", "Quickshot", "Heavy Metal", "Ultracannon"]
	upgrade_descriptions = ["Increases range by 33%.", "Cannonballs get +1 pierce.", "The cannon shoots 20% faster.", "The cannonballs get an additional +2 pierce.", "Like a machine gun, but a cannon."]
	start_radius = 64
	cost = 500
	value = cost
	
func _process(delta):
	can_place = $body.get_overlapping_areas().size() < 1 && $body.get_overlapping_bodies().size() < 1 && position.x < get_viewport().get_visible_rect().size.x - 160 && position.x > 0 && position.y > 0 && position.y < get_viewport().get_visible_rect().size.y
	if !placed:
		return
	target = null
	if $radius.get_overlapping_areas().size() > 0:
		target = $radius.get_overlapping_areas().front()
		wr = weakref(target)

func upgrade():
	value += upgrade_costs[level]
	level += 1
	if level == 1:
		inc_radius(32)
	elif level == 2:
		bullet_health += 1
	elif level == 3:
		fire_rate -= 0.2
	elif level == 4:
		bullet_health += 2
	elif level == 5:
		fire_rate = 0.2
		bullet_health = 5
		inc_radius(32)
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

func _on_body_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && placed:
		game.selected_tower = self
