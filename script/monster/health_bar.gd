extends ProgressBar

# usually used for bosses

@onready var target = get_parent()

func _ready():
	max_value = target.health


func _process(delta):
	value = target.health
	
	if not visible and value < max_value:
		show()
