extends PanelContainer

@onready var game = get_tree().root.get_node("Game")

@onready var container = $VBoxContainer/ScrollContainer/GridContainer

const tower_panel: PackedScene = preload("res://scenes/tower_panel.tscn") 

func _ready():
	for tower in Towers.towers:
		var panel = tower_panel.instantiate()
		panel.purchase.connect(_on_tower_purchase.bind())
		container.add_child(panel)
		panel.set_tower(tower)


func _on_tower_purchase(tower: String) -> void:
	game.purchase_tower(tower)


func _process(_delta):
	pass


func _on_cancel_button_pressed() -> void:
	hide()
