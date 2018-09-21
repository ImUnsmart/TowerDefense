extends Node2D

var target
var bullet = preload("res://scenes/cannonball.tscn")
var fire_rate = 1
var bullet_health
var display_name
var description
var upgrade_costs
var upgrade_names
var upgrade_descriptions
var start_radius
var level = 0
var wr
var can_place = true
var placed = false
var value

func init():
	bullet_health = 2
	display_name = "Cannon"
	description = "Shoots slow cannonballs that hit multiple enemies."
	upgrade_costs = [250, 500, 1000, 4000, 25000]
	upgrade_names = ["Longer Range", "Bigger Cannonballs", "Quickshot", "Heavy Metal", "Ultracannon"]
	upgrade_descriptions = ["Increases range by 33%.", "Cannonballs get +1 pierce.", "The cannon shoots 20% faster.", "The cannonballs get an additional +2 pierce.", "Like a machine gun, but a cannon."]
	start_radius = 64
	value = get_cost()

func _ready():
	init()
	var radius = CollisionShape2D.new()
	radius.set_name("radius")
	radius.set_shape(CircleShape2D.new())
	$radius.add_child(radius)
	$shoot_timer.wait_time = fire_rate
	$radius/radius.shape.radius = start_radius
	pass
	
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
		fire_rate = 0.4
		bullet_health = 5
		inc_radius(32)
	$shoot_timer.wait_time = fire_rate
	
func inc_radius(amt):
	$radius/radius.shape.radius += amt
	$radius.hide()
	$radius.show()

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
		get_tree().root.get_node("Game").selected_tower = self
		
func get_value():
	return round(value * 0.79)

func get_cost():
	return 500
