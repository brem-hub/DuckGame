extends KinematicBody2D


#Speed of the player, cannot be changed
export var MOVE_SPEED_X : int
export var MOVE_SPEED_Y : int
#Max speed of the player, cannot be changed
export var MAX_SPEED : int

export var MAX_HEALTH : int
export var SLOW_DOWN_STAMINA_MAX: int #How long can you slow down for
export var SLOW_DOWN_STAMINA_USE: int #How long can you slow down for
export var SLOW_DOWN_STAMINA_RECOVER: int #How long can you slow down for
export var SLOW_DOWN_MULTIPLIER = 10 #How much does everything slow down by
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
onready var move_speed_x = MOVE_SPEED_X
onready var move_speed_y = MOVE_SPEED_Y
#Remaining health
onready var health = MAX_HEALTH
#Current stamina remaining for slow down
onready var slow_down_stamina = SLOW_DOWN_STAMINA_MAX

var moving_side : int
var slow_down = false #Is time being slowed?
var slow_down_recover = false #Ran out of slow down stamina?

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
	#Slow Down
	if Input.is_action_pressed("slow_down") && !slow_down_recover && slow_down_stamina != 0:
		slow_down = true
		slow_down_stamina = move_toward(slow_down_stamina, 0, delta * SLOW_DOWN_STAMINA_USE)
		if slow_down_stamina == 0:
			slow_down_recover = true
	else:
		slow_down = false
		slow_down_stamina = move_toward(slow_down_stamina, SLOW_DOWN_STAMINA_MAX, delta * SLOW_DOWN_STAMINA_RECOVER)
		if slow_down_stamina == SLOW_DOWN_STAMINA_MAX:
			slow_down_recover = false
	#Speeding Up when in the river and slowing down when is out of it.
	#TODO: If needed, if not is_in_river: move_speed = MOVE_SPEED <- slow down immediately
	if is_in_river:
		move_speed_y = move_toward(move_speed_y, MAX_SPEED, river.INC_SPEED)
#		if move_speed_y < MAX_SPEED:
#			move_speed_y += river.INC_SPEED
	if not is_in_river:
		move_speed_y = move_toward(move_speed_y, MOVE_SPEED_Y, 2*river.INC_SPEED)
#		if move_speed_y > MOVE_SPEED_Y:
#			move_speed_y -= 2 * river.INC_SPEED
#		else:
#			move_speed_y = MOVE_SPEED_Y	
	var move_vec = Vector2(1, 0)
	
	if slow_down:
		move_vec.x /= SLOW_DOWN_MULTIPLIER
	
	if Input.is_action_pressed("move_up"):
		moving_side = -1
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		moving_side = 1
		move_vec.y += 1
	
	move_and_collide(Vector2(move_vec.x * move_speed_x, move_vec.y * move_speed_y) * delta)
	if is_in_river:
		move_and_slide(Vector2.RIGHT * river.PUSH_POWER)

func _take_damage():
	#Code to run when taking damage
	health -= 1
	print("Health: " + str(health))
	#Remove a duckling
	duckling_controller.kill_duckling() #rip duckling
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
