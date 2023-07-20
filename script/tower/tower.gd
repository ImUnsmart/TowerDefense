extends Area2D

class_name Tower

@onready var game = get_tree().root.get_node("Game")

@onready var sprite = $AnimatedSprite2D

@onready var detection = $Detection
@onready var detection_shape = detection.get_node("CollisionShape2D")

@export var tower_name = ""
@export_enum("Rotate", "Face", "None") var rotate: int = 0

var placing: bool = true
var target: Node2D = null
var lookahead_position: Vector2 = Vector2.ZERO
var _worth: int = 0
var level: int = 0

var redraw: bool = false

func _ready():
	detection_shape.shape = CircleShape2D.new()

	_worth += Towers.get_tower_data(tower_name).cost

	upgrade()


func upgrade() -> void:
	level += 1
	_worth += Towers.get_tower_data(tower_name).levels[level - 1].cost


func get_worth() -> int:
	return ceil(_worth * 0.75)


func find_target() -> void:
	target = null

	for node in detection.get_overlapping_areas():
		var monster = node.get_parent()
		if target == null or target.progress_ratio < monster.progress_ratio:
			target = monster


func look_at_target(delta: float, lookahead_amount: float) -> void:
	if not target or not weakref(target).get_ref():
		return
	
	var old_progress = target.progress
	
	target.progress += target.speed * delta * lookahead_amount
	lookahead_position = target.global_position

	if rotate == 0:
		rotation = lerp_angle(rotation, (lookahead_position - global_position).angle(), 0.1)
	elif rotate == 1:
		if target.global_position.x > global_position.x:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true

	target.progress = old_progress


func _process(_delta):
	if game.selected_tower == self:
		queue_redraw()
		redraw = true
	elif redraw:
			redraw = false
			queue_redraw()

	if placing:
		return

func _physics_process(_delta):
	if placing:
		return


func _draw():
	if get_overlapping_areas().size() > 0:
		draw_circle(Vector2.ZERO, detection_shape.shape.radius, Color(1, 0, 0, 0.25))
	elif game.selected_tower == self:
		draw_circle(Vector2.ZERO, detection_shape.shape.radius, Color(0, 0, 0, 0.25))
