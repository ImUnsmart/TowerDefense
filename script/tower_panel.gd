extends PanelContainer

signal purchase(tower: String)

@onready var name_lbl: Label = $MarginContainer/VBoxContainer/Name
@onready var desc: Label = $MarginContainer/VBoxContainer/Desc
@onready var texture: TextureRect = $MarginContainer/VBoxContainer/TextureRect
@onready var purchase_button = $MarginContainer/VBoxContainer/PurchaseButton

var tower: String = ""

func _ready():
	pass # Replace with function body.

func set_tower(tower_: String) -> void:
	tower = tower_
	var data = Towers.get_tower_data(tower)
	name_lbl.text = data["name"]
	desc.text = data["description"]
	texture.texture = AtlasTexture.new()
	texture.texture.atlas = data["texture"]
	var size_ = min(texture.texture.atlas.get_size().x, texture.texture.atlas.get_size().y)
	texture.texture.region = Rect2(0, 0, size_, size_)
	purchase_button.text = str(data["cost"])
	

func _process(_delta: float):
	pass


func _on_purchase_button_pressed() -> void:
	emit_signal("purchase", tower)
