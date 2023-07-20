extends Node2D

const gold_sprite: String = "res://assets/gold.png"

var velocity: Vector2 = Vector2(0, -100)

@onready var die_timer = $DieTimer
@onready var gold_label = $RichTextLabel

func _ready():
	pass

func set_amount(amount: int) -> void:
	gold_label.text = "[center][img=24]%s[/img]%s[/center]" % [gold_sprite, amount]

func _process(_delta):
	modulate.a = die_timer.time_left / die_timer.wait_time

func _physics_process(delta):
	position += velocity * delta


func _on_die_timer_timeout() -> void:
	call_deferred("queue_free")