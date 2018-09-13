extends Node2D

var target
export(PackedScene) var bullet
export var fire_rate = 1
export var bullet_health = 2
var display_name = "Cannon"
var description = "Shoots slow cannonballs that hit multiple enemies."
var upgrade_costs = [250, 500, 1000, 4000, 25000]
var upgrade_names = ["Longer Range", "Bigger Cannonballs", "Quickshot", "Heavy Metal", "Ultracannon"]
var upgrade_descriptions = ["Increases range by 33%.", "Cannonballs get +1 pierce.", "The cannon shoots 20% faster.", "The cannonballs get an additional +2 pierce.", "Like a machine gun, but a cannon."]
var cost = 500
var level = 0
var wr

func _ready():
	var radius = CollisionShape2D.new()
	radius.set_name("radius")
	radius.set_shape(CircleShape2D.new())
	$radius.add_child(radius)
	$shoot_timer.wait_time = fire_rate
	$radius/radius.shape.radius = 96
	pass
	
func _process(delta):
	target = null
	if $radius.get_overlapping_bodies().size() > 0:
		target = $radius.get_overlapping_bodies().front()
		wr = weakref(target)

func upgrade():
	level += 1
	if level == 1:
		$radius/radius.shape.radius += 32
	elif level == 2:
		bullet_health += 1
	elif level == 3:
		fire_rate -= 0.2
	elif level == 4:
		bullet_health += 2
	elif level == 5:
		fire_rate = 0.4
		bullet_health = 5
		$radius/radius.shape.radius += 32
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
	if event is InputEventMouseButton:
		get_tree().root.get_node("Game").selected_tower = self
