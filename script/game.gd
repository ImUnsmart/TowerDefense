extends Node

@onready var monster_path: Node = $MonsterPath
@onready var width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
@onready var height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
@onready var center_point: Vector2 = Vector2(width / 2.0, height / 2.0)

@export var health: int = 25
const health_sprite: String = "res://assets/heart.png"
@onready var health_counter: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/VBoxContainer/HealthCounter

@export var gold: int = 15
const gold_sprite: String = "res://assets/gold.png"
@onready var gold_counter: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/VBoxContainer/GoldCounter

@export var starting_wave: int = 1
const wave_sprite: String = "res://assets/skull.png"
@onready var wave_counter: RichTextLabel = $CanvasLayer/MarginContainer/VBoxContainer/VBoxContainer/WaveCounter

@onready var tower_shop: Node = $CanvasLayer/MarginContainer/TowerShop

var fast_forward: bool = false
@onready var fast_forward_button = $CanvasLayer/MarginContainer/HBoxContainer/FastButton

@onready var spawner = $Spawner

@onready var tower_picker = $TowerPicker

@onready var tower_info = $CanvasLayer/MarginContainer/TowerInfo

var selected_tower: Node = null
var shake: float = 0.0

func _ready() -> void:
	randomize()

	# update counters
	set_gold(gold)
	set_health(health)

func set_gold(amount: int) -> void:
	gold = amount
	gold_counter.text = "[img=24]%s[/img] %s" % [gold_sprite, gold]


func add_gold(amount: int) -> void:
	set_gold(gold + amount)


func set_health(amount: int) -> void:
	health = amount
	health_counter.text = "[img=24]%s[/img] %s" % [health_sprite, health]


func add_health(amount: int) -> void:
	set_health(health + amount)


func _process(_delta) -> void:
	$Camera2D.offset = Vector2(randf_range(-shake, shake), randf_range(-shake, shake))

	shake = lerp(shake, 0.0, 0.25)

	if tower_picker.get_overlapping_areas().size() > 0:
		var closest = null
		var dist = 9e9
		
		for tower in tower_picker.get_overlapping_areas():
			var tower_dist = tower.position.distance_to(tower_picker.global_position)
			if tower_dist < dist:
				closest = tower
				dist = tower_dist

		selected_tower = closest

		if selected_tower:
			tower_info.set_tower(selected_tower)
	else:
		if selected_tower != null and not selected_tower.placing:
			selected_tower = null
	
	if selected_tower and not selected_tower.placing:
		if not tower_info.is_visible_in_tree():
			tower_info.display(selected_tower)
	else:
		if tower_info.is_visible_in_tree():
			tower_info.hide()
		
func spawn_monster(monster: PackedScene) -> void:
	var monster_instance = monster.instantiate()
	monster_path.add_child(monster_instance)


func purchase_tower(tower: String) -> void:
	var data = Towers.get_tower_data(tower)
	if data.cost > gold:
		return
	
	var tower_scene = data["scene"].duplicate()
	var tower_instance = tower_scene.instantiate()
	$Towers.add_child(tower_instance)
	selected_tower = tower_instance
	tower_shop.hide()


func shake_screen(amount: int) -> void:
	shake = max(shake, amount)

func _on_shop_button_pressed() -> void:
	tower_picker.position = Vector2.ZERO
	if selected_tower:
		if selected_tower.placing:
			selected_tower.queue_free()
		selected_tower = null
	
	tower_shop.show()


func _on_fast_button_pressed() -> void:
	if not spawner.spawning:
		spawner.wave = starting_wave - 1
		spawner.next_wave()
		fast_forward_button.text = "Fast"
		return
		
	if fast_forward:
		fast_forward_button.text = "Fast"
		fast_forward = false
		Engine.time_scale = 1.0
	else:
		fast_forward_button.text = "Normal"
		fast_forward = true
		Engine.time_scale = 2.0


func _input(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		if selected_tower and selected_tower.placing:
			selected_tower.position = event.position


func _unhandled_input(event):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if selected_tower == null or not selected_tower.placing:
			if event.pressed:
				tower_picker.global_position = event.position
		else:
			if not event.pressed:
				if selected_tower.get_overlapping_areas().size() > 0:
					return
				if gold < Towers.get_tower_data(selected_tower.tower_name)["cost"]:
					selected_tower.queue_free()
					return
					
				add_gold(-Towers.get_tower_data(selected_tower.tower_name)["cost"])

				selected_tower.placing = false

				tower_info.set_tower(selected_tower)

				selected_tower = null


func _on_tower_info_sell() -> void:
	if not selected_tower:
		return
	
	add_gold(floor(Towers.get_tower_data(selected_tower.tower_name)["cost"] * 0.75))
	selected_tower.queue_free()
	selected_tower = null


func _on_tower_info_upgrade() -> void:
	if not selected_tower:
		return
	
	var cost: int = Towers.get_tower_data(selected_tower.tower_name).levels[selected_tower.level].cost

	if gold > cost:
		add_gold(-cost)
		selected_tower.upgrade()
		tower_info.set_tower(selected_tower)
