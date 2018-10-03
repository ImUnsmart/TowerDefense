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
