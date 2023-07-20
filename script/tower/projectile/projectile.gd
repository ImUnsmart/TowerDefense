extends Area2D

const explode_effect_scene: PackedScene = preload("res://scenes/explosion_particles.tscn")
const hit_effect_scene: PackedScene = preload("res://scenes/hit_particles.tscn")

@onready var game = get_tree().root.get_node("Game")
@onready var effects = game.get_node("Effects")

@export var speed: float = 200.0
@export var damage: int = 1
@export var hitpoints: int = 1
@export var hit_effect_color = Color(0, 0, 0, 0)
@export var starting_angular_velocity: float = 0.0

var hit = {}

var velocity: Vector2 = Vector2.ZERO
var angular_velocity: float = 0.0

func _ready():
	if starting_angular_velocity:
		angular_velocity = randf_range(-starting_angular_velocity, starting_angular_velocity)


func _process(_delta) -> void:
	pass

func _physics_process(delta) -> void:
	$Sprite2D.rotation += angular_velocity * delta
	
	position += velocity * delta


func die() -> void:
	if hit_effect_color != Color(0, 0, 0, 0):
		hit_effect()
	call_deferred("queue_free")


func target(target_pos: Vector2) -> void:
	velocity = (target_pos - position).normalized() * speed
	rotation = velocity.angle() + PI / 2


func target_offset(target_pos: Vector2, offset: float) -> void:
	var target_angle = (target_pos - position).angle() + offset
	velocity = Vector2(cos(target_angle), sin(target_angle)) * speed
	rotation = velocity.angle() + PI / 2


func hit_monster(monster: PathFollow2D) -> void:
	monster.hurt(damage)
	hit[monster] = true
	hitpoints -= 1
	if hitpoints <= 0:
		die()


func _on_area_entered(area:Area2D)->void:
	var parent = area.get_parent()

	if parent in hit:
		return

	if parent is PathFollow2D:
		hit_monster(parent)


func hit_effect() -> void:
	var effect = hit_effect_scene.instantiate()
	effect.position = position
	effects.add_child(effect)
	effect.process_material.color = hit_effect_color
		

func explosion() -> void:
	var effect = explode_effect_scene.instantiate()
	effect.position = position
	effects.add_child(effect)
				
		