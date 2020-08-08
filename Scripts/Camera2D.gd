extends Camera2D

onready var player = get_parent()

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position.x = player.position.x + 400
