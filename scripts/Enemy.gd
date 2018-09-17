extends KinematicBody2D

var path
var pathPos = 0
export var speed = 2
export var health = 1
export var damage = 1
var maxhp
var dot_count

func _ready():
	maxhp = health
	pass
	
func _process(delta):
	if path != null:
		path.set_offset(pathPos)
		position.x = path.position.x + 16
		position.y = path.position.y + 12
	pathPos += speed
	var hp = float(health) / maxhp
	if hp <= 0.75 && hp > 0.5:
		$normal.hide()
		$hurt.show()
	if hp <= 0.5 && hp > 0.25:
		$normal.hide()
		$hurt.hide()
		$hurt2.show()
	if hp <= 0.25:
		$normal.hide()
		$hurt.hide()
		$hurt2.hide()
		$hurt3.show()
	
	
func hurt(i):
	health -= i
	if health < 1:
		queue_free()
		get_tree().root.get_node("Game").add_money(10)
		var e = get_tree().root.get_node("Game").explosion(position)
		e.set_colors(Color(1, 0, 0, 1), Color(0, 0, 0, 0))

func dot(time, count):
	$dot_timer.wait_time = time
	$dot_timer.start()
	dot_count = count
	$fire.show()

func _on_dot_timer_timeout():
	hurt(1)
	dot_count -= 1
	if dot_count == 0:
		$dot_timer.stop()
		$fire.hide()
