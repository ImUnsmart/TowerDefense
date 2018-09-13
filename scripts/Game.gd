extends Node

var selected_tower
var lives = 100
var money = 0

var placed = false
var selected = -1

const cannon = preload("res://scenes/cannon.tscn")

func _ready():
	damage(0)
	set_money(50000)
	pass
	
func _process(delta):
	for t in $towers.get_children():
		if selected_tower != null:
			if selected_tower == t:
				t.get_node("radius").show()
				if t.level < 5:
					$GUI/upgrade/upgrade.show()
					if money >= t.upgrade_costs[t.level]:
						$GUI/upgrade/upgrade.disabled = false
					else:
						$GUI/upgrade/upgrade.disabled = true
					$GUI/upgrade/upgrade/u_name.text = t.upgrade_names[t.level]
					$GUI/upgrade/upgrade/u_desc.text = t.upgrade_descriptions[t.level]
					$GUI/upgrade/upgrade/u_cost.text = "Cost: " + String(t.upgrade_costs[t.level])
				else:
					$GUI/upgrade/upgrade.hide()
			else:
				if t.get_node("radius").is_visible_in_tree():
					t.get_node("radius").hide()

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		if get_viewport().get_mouse_position().x < get_viewport().get_visible_rect().size.x - 160:
			if selected_tower != null:
				selected_tower.get_node("radius").hide()
				selected_tower = null
				$GUI/upgrade/t_name.text = ""
				$GUI/upgrade/t_desc.text = ""
				$GUI/upgrade/upgrade.hide()
	if event is InputEventMouseButton && !event.pressed:
		placeTowerAttempt(cannon)
	

func damage(i):
	lives -= i
	$GUI/Lives/Label.text = String(lives)
	
func set_money(i):
	money = i
	$GUI/Cash/Label.text = String(money)

func add_money(i):
	set_money(money + i)

func _on_upgrade_pressed():
	var cost = selected_tower.upgrade_costs[selected_tower.level]
	if money >= cost:
		set_money(money - cost)
		selected_tower.upgrade()

func placeTowerAttempt(t):
	if selected == 0:
		if money >= 500:
			var tower = t.instance()
			tower.position = get_viewport().get_mouse_position()
			$towers.add_child(tower)
			set_money(money - 500)
	selected = -1

func _on_cannon_pressed():
	selected = 0
