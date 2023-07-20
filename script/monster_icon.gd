extends PanelContainer

signal purchase(monster: String)

@onready var name_lbl = $MarginContainer/VBoxContainer/Name
@onready var image = $MarginContainer/VBoxContainer/TextureRect
@onready var description = $MarginContainer/VBoxContainer/Desc
@onready var purchase_btn = $MarginContainer/VBoxContainer/PurchaseButton

var monster: String = ""

func _ready():
	pass # Replace with function body.

func set_monster(monster_: String) -> void:
	monster = monster_
	name_lbl.text = MonsterData.get_mname(monster)
	image.texture = MonsterData.get_icon(monster)
	description.text = MonsterData.get_description(monster)
	purchase_btn.text = "%s" % MonsterData.get_cost(monster)

func _process(_delta) -> void:
	pass


func _on_purchase_button_pressed() -> void:
	emit_signal("purchase", monster)
