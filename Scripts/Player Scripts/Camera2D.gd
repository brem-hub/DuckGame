extends Camera2D

onready var root = get_tree().get_root().get_child(0)
onready var player = get_parent()

var distance_from_player = 400
var shake_multiplier = 5
var paused = false
var victory = false

func _ready():
	set_as_toplevel(true)

func _physics_process(delta):
	if victory:	return
	position.x = player.position.x + distance_from_player
	position.y = 0
	if !$Control/Timer.is_stopped() && !paused:
		position.x += rand_range(-shake_multiplier, shake_multiplier)
		position.y += rand_range(-shake_multiplier, shake_multiplier)
	if Input.is_action_just_pressed("pause") && player.health != 0:
		_pause()

func _pause():
	paused = !paused
	$Control/Timer.paused = paused
	get_tree().paused = paused
	$Control/Pause.visible = paused
