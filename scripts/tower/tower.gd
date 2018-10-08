extends Node2D

var target
var fire_rate = 1
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
var game
var cost = 0

func _ready():
	init()
	game = get_tree().root.get_node("Game")
	var radius = CollisionShape2D.new()
	radius.set_name("radius")
	radius.set_shape(CircleShape2D.new())
	$radius.add_child(radius)
	$radius/radius.shape.radius = start_radius
	
func _process(delta):
	can_place = $body.get_overlapping_areas().size() < 1 && $body.get_overlapping_bodies().size() < 1 && position.x < get_viewport().get_visible_rect().size.x - 160 && position.x > 0 && position.y > 0 && position.y < get_viewport().get_visible_rect().size.y
	var path = game.get_node("map_objects")
	if path in $body.get_overlapping_areas():
		can_place = false
	target = null
	var obj = $radius.get_overlapping_areas()
	if obj.size() >= 1:
		target = obj.front()
		while !"enemy" in target.get_name().to_lower():
			obj.remove(0)
			if obj.size() == 0:
				target = null
				return
			target = obj.front()
		wr = weakref(target)

func get_value():
	return round(value * 0.79)

func get_cost():
	return cost
	
func inc_radius(amt):
	$radius/radius.shape.radius += amt
	$radius.hide()
	$radius.show()

func _on_body_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton && placed:
		game.selected_tower = self
