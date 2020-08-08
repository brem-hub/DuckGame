extends Camera2D

var distance_from_player = 400
var shake_multiplier = 5
onready var player = get_parent()

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position.x = player.position.x + distance_from_player
	position.y = 0
	if !$Timer.is_stopped():
		position.x += rand_range(-shake_multiplier, shake_multiplier)
		position.y += rand_range(-shake_multiplier, shake_multiplier)
