extends Area2D

var path
var pathPos = 0
var speed = 1
var health = 1
var damage = 1
var worth = 10
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
	
func hurt(i):
	health -= i
	if health < 1:
		queue_free()
		get_tree().root.get_node("Game").add_money(worth)
		var e = get_tree().root.get_node("Game").explosion(position)
		e.set_colors(Color(1, 0, 0, 1), Color(0, 0, 0, 0))
		return
	var hp = float(health) / maxhp
	if hp <= 0.75 && hp > 0.5:
		change($tex_hurt)
	if hp <= 0.5 && hp > 0.25:
		change($tex_hurt2)
	if hp <= 0.25:
		change($tex_hurt3)

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

func _on_Enemy_area_entered(area):
	if "bullet" in area.get_name():
		hurt(area.damage)
		area.health -= 1
		
func change(tex):
	for t in get_children():
		if "tex" in t.get_name():
			t.hide()
	tex.show()