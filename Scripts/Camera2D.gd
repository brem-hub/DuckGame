extends Camera2D

onready var root = get_tree().get_root().get_child(0)
onready var player = get_parent()

var distance_from_player = 400
var shake_multiplier = 5
var paused = false

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	position.x = player.position.x + distance_from_player
	position.y = 0
	if !$Timer.is_stopped() && !paused:
		position.x += rand_range(-shake_multiplier, shake_multiplier)
		position.y += rand_range(-shake_multiplier, shake_multiplier)
	if Input.is_action_just_pressed("pause"):
		paused = !paused
		$Timer.paused = paused
		get_tree().paused = paused
		$Control.visible = paused
