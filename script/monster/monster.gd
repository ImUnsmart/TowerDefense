extends PathFollow2D

@onready var game = get_tree().root.get_node("Game")
@onready var effects = game.get_node("Effects")

@export var speed: float = 35.0
@export var health: int = 3
@export var value: int = 1
@export var hit_color: Color = Color(1, 1, 1, 1)

const hit_effect_scene: PackedScene = preload("res://scenes/hit_particles.tscn")
const gold_effect_scene: PackedScene = preload("res://scenes/gold_effect.tscn")

func _ready() -> void:
	pass

func _process(delta) -> void:
	pass


func _physics_process(delta) -> void:
	progress += speed * delta
	if progress_ratio >= 1.0:
		call_deferred("queue_free")
		game.add_health(-1)


func hurt(amount: int) -> void:
	health -= amount
	if health <= 0:
		die()
	
	hit_effect(hit_color)


func die() -> void:
	call_deferred("queue_free")
	gold_effect(value)
	game.add_gold(value)


func gold_effect(amount: int) -> void:
	var effect = gold_effect_scene.instantiate()
	effect.position = position
	effects.add_child(effect)
	effect.set_amount(amount)


func hit_effect(color: Color) -> void:
	var effect = hit_effect_scene.instantiate()
	effect.position = position
	effects.add_child(effect)
	effect.process_material.color = color
		
