extends AnimatedSprite

#Script to slow down animation when in slow mode & set z index
onready var root = get_tree().get_root().get_child(1)
onready var player = root.get_node("Player")

func _physics_process(delta):
	#Sets z index that way things will look like they are in a 3d space
	z_index = get_parent().position.y
	#Slow down animations when player does
	if player.slow_down:
		speed_scale = 0.5
	else:
		speed_scale = 1
