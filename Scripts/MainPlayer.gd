extends KinematicBody2D


#Speed of the player, cannot be changed
export  var  MOVE_SPEED : int

export var MAX_SPEED : int
#Root element (Scene)
onready var root = get_tree().get_root().get_child(0)

#If player is in the river
var is_in_river : bool

#River Node
onready var river = root.get_node("River")

#Current speed, can be changed
onready var move_speed = MOVE_SPEED

#Remaining health
var health = 3


var moving_side : int

func _init():
	#Assume that we begin on the ground 
	is_in_river = true
	moving_side = 0
func _ready():
	print(global_position)
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
	print("MAMA ", move_speed)
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
#	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * move_speed * delta)
	if is_in_river:
		move_and_slide(Vector2.RIGHT * river.PUSH_POWER)

func _take_damage():
	#Code to run when taking damage
	health -= 1
	#Remove a duckling
	print("Health: " + str(health))

func _on_River_body_entered(body):
	print("in the river")
	is_in_river = true


func _on_River_body_exited(body):
	print("out of the river")
	is_in_river = false
