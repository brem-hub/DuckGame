extends KinematicBody2D


#Speed of the player, cannot be changed
export var MOVE_SPEED : int
#Max speed of the player, cannot be changed
export var MAX_SPEED : int

export var MAX_HEALTH : int
#Camera settings
export var camera_distance_from_player = 400
export var camera_shake_multiplier = 5
export var camera_timer = 0.5
export var camera_limit_left = 0
export var camera_limit_right = 0

#Nodes
onready var root = get_tree().get_root().get_child(0)
onready var river = root.get_node("River")
onready var duckling_controller = root.get_node("DucklingManager")

#If player is in the river
var is_in_river : bool

#Current speed, can be changed
onready var move_speed = MOVE_SPEED
onready var health = MAX_HEALTH
#Remaining health

var moving_side : int

func _ready():
	#Runs at the start
	$Camera2D.distance_from_player = camera_distance_from_player
	$Camera2D.shake_multiplier = camera_shake_multiplier
	$Camera2D/Timer.wait_time = camera_timer
	$Camera2D.limit_left = camera_limit_left
	$Camera2D.limit_right = camera_limit_right

func _init():
	#Assume that we begin on the ground 
	is_in_river = true
	moving_side = 0

func _physics_process(delta):
	#Speeding Up when in the river and slowing down when is out of it.
	#TODO: If needed, if not is_in_river: move_speed = MOVE_SPEED <- slow down immediately
	if is_in_river:
		if move_speed < MAX_SPEED:
			move_speed += river.INC_SPEED
	if not is_in_river:
		if move_speed > MOVE_SPEED:
			move_speed -= 2 * river.INC_SPEED
		else:
			move_speed = MOVE_SPEED	
	var move_vec = Vector2()
	
	if Input.is_action_pressed("speed_up"):
		move_vec.x = 0.1
	else:
		move_vec.x = 1
		
	if Input.is_action_pressed("move_up"):
		moving_side = -1
		move_vec.y -= 5
	if Input.is_action_pressed("move_down"):
		moving_side = 1
		move_vec.y += 5
	
	move_and_collide(move_vec * move_speed * delta)
	if is_in_river:
		move_and_slide(Vector2.RIGHT * river.PUSH_POWER)

func _take_damage():
	#Code to run when taking damage
	health -= 1
	print("Health: " + str(health))
	#Remove a duckling
	duckling_controller.kill_duckling()
	#Shakith the camera
	$Camera2D/Timer.start()

func _on_River_body_entered(body):
	if body.name == "Player":
		print("in the river")
		is_in_river = true


func _on_River_body_exited(body):
	if body.name == "Player":
		print("out of the river")
		is_in_river = false
