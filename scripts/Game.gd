extends Node

var selected_tower
var placing
var lives = 100
var money = 0
## when you click next wave to start the game, this is incremented, meaning 'wave + 1' is actually the wave you start with.
var wave = 0

var pressed = true

var costs = [ 500, 300, 900, 450 ]

const cannon = preload("res://scenes/tower/tower_cannon.tscn")
const laser = preload("res://scenes/tower/tower_laser.tscn")
const bank = preload("res://scenes/tower/tower_bank.tscn")
const lightning = preload("res://scenes/tower/tower_lightning.tscn")

const explode = preload("res://scenes/particle_explosion.tscn")

func _ready():
	damage(0)
	set_money(20000)
	pass
	
func _process(delta):
	var hide = false
	for t in $towers.get_children():
		if selected_tower != null:
			if selected_tower == t:
				hide = true
				t.get_node("radius").show()
				$GUI/upgrade/t_name.text = t.display_name
				$GUI/upgrade/t_desc.text = t.description
				$GUI/upgrade/sell.show()
				$GUI/upgrade/sell/cost.text = "$" + String(selected_tower.get_value())
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
		if selected_tower == null || selected_tower != t:
			if t.get_node("radius").is_visible_in_tree():
				t.get_node("radius").hide()
	if $GUI/buttons.is_visible_in_tree():
		if hide:
			$GUI/buttons.hide()
	if !$GUI/buttons.is_visible_in_tree():
		if !hide:
			$GUI/buttons.show()
	if !$spawner.spawning && $spawner.get_node("enemies").get_child_count() == 0:
		$GUI/buttons/NextWave.show()
	else:
		$GUI/buttons/NextWave.hide()		
	if placing != null:
		placing.position = get_viewport().get_mouse_position()
		if !placing.get_node("radius").is_visible_in_tree():
			placing.get_node("radius").show()
		selected_tower = null
	pressed = false

func _input(event):
	if event is InputEventMouseButton && event.pressed:
		if get_viewport().get_mouse_position().x < get_viewport().get_visible_rect().size.x - 160:
			if selected_tower != null:
				deselect()
	if event is InputEventMouseButton && !event.pressed:
		if !pressed:
			if get_viewport().get_mouse_position().x > get_viewport().get_visible_rect().size.x - 160 && placing != null:
				placing.queue_free()
				placing = null
				selected_tower = null
				return
			pressed = true
		placeTowerAttempt()

func damage(i):
	lives -= i
	$GUI/Lives/Label.text = String(lives)
	
func set_money(i):
	money = i
	$GUI/Cash/Label.text = String(money)

func add_money(i):
	set_money(money + i)

func inc_wave():
	wave += 1
	$GUI/Wave/Label.text = String(wave)
	$spawner.start(wave)

func wave_money():
	add_money(101 - wave)
	var money = 0
	for t in $towers.get_children():
		if "tower_bank" in t.get_name():
			money += t.get_money_produced()
			var e = explosion(t.position)
			e.set_colors(Color(0, 0, 0, 1), Color(1, 1, 0, 0))
	add_money(money)
	
func deselect():
	selected_tower = null
	$GUI/upgrade/t_name.text = ""
	$GUI/upgrade/t_desc.text = ""
	$GUI/upgrade/upgrade.hide()
	$GUI/upgrade/sell.hide()

func placeTowerAttempt():
	if placing != null && placing.can_place:
		set_money(money - placing.get_cost())
		selected_tower = placing
		placing.placed = true
		placing = null
	
func explosion(position, color=Color(1,0,0), fade=Color(0,0,0,0)):
	var e = explode.instance()
	e.set_colors(color, fade)
	e.position = position
	add_child(e)
	return e

func show_dialog(title, text):
	$GUI/Information.window_title = title
	$GUI/Information.dialog_text = text
	$GUI/Information.popup()
	
func _on_upgrade_pressed():
	var cost = selected_tower.upgrade_costs[selected_tower.level]
	if money >= cost:
		set_money(money - cost)
		selected_tower.upgrade()

func _on_NextWave_pressed():
	inc_wave()

func _on_cannon_pressed():
	if money >= costs[0]:
		var tower = cannon.instance()
		var pos = get_viewport().get_mouse_position()
		tower.position = pos
		$towers.add_child(tower)
		placing = tower
		
func _on_laser_pressed():
	if money >= costs[1]:
		var tower = laser.instance()
		var pos = get_viewport().get_mouse_position()
		tower.position = pos
		$towers.add_child(tower)
		placing = tower

func _on_bank_pressed():
	if money >= costs[2]:
		var tower = bank.instance()
		var pos = get_viewport().get_mouse_position()
		tower.position = pos
		$towers.add_child(tower)
		placing = tower

func _on_lightning_pressed():
	if money >= costs[3]:
		var tower = lightning.instance()
		var pos = get_viewport().get_mouse_position()
		tower.position = pos
		$towers.add_child(tower)
		placing = tower

func _on_sell_pressed():
	var value = selected_tower.get_value()
	add_money(value)
	var e = explosion(selected_tower.position)
	e.set_colors(Color(0.2, 0.2, 0.2, 1), Color(0, 0, 0, 0))
	selected_tower.queue_free()
	deselect()
