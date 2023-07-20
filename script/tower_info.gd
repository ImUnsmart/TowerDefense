extends Control

signal sell
signal upgrade

const gold_sprite = "res://assets/gold.png"

@onready var tower_name = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/TowerName
@onready var upgrade_name = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/UpgradeName
@onready var upgrade_desc = $VBoxContainer/PanelContainer/MarginContainer/VBoxContainer/UpgradeDesc
@onready var sell_button = $VBoxContainer/HBoxContainer/SellButton
@onready var upgrade_button = $VBoxContainer/HBoxContainer/UpgradeButton

func _ready():
	pass # Replace with function body.


func set_tower(tower: Tower) -> void:
	sell_button.text = str(tower.get_worth())
	var data = Towers.get_tower_data(tower.tower_name)
	tower_name.text = "[center][b]%s[/b][/center]" % data.name
	if tower.level >= data.levels.size():
		upgrade_name.text = "Max Level"
		upgrade_desc.text = "[center]This tower is at its maximum level.[/center]"
		upgrade_button.disabled = true
		return
	upgrade_button.disabled = false
	upgrade_name.text = data.levels[tower.level].name
	upgrade_desc.text = "[center]%s\n\n[img=16]%s[/img] %s[/center]" % [data.levels[tower.level].desc, gold_sprite, data.levels[tower.level].cost]


func display(tower: Tower) -> void:
	set_tower(tower)
	show()

func _process(_delta):
	pass


func _on_sell_button_pressed():
	emit_signal("sell")


func _on_upgrade_button_pressed():
	emit_signal("upgrade")
