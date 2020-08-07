extends KinematicBody2D


#Speed of the player
export  var  MOVE_SPEED : int

#Root element (Scene)
onready var root = get_tree().get_root().get_child(0)

#If player is in the river
var is_in_river : bool

var moving_side: int

#River Node
onready var river = root.get_node("River")

func _init():
	#Assume that we begin on the ground
	moving_side = 0
	is_in_river = false
	
func _physics_process(delta):
	moving_side = 0
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		moving_side += 1
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		moving_side += 3
		move_vec.y += 1
	if Input.is_action_pressed("move_left"):
		moving_side += 5
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		moving_side += 9
		move_vec.x += 1
	move_vec = move_vec.normalized()
	
	move_and_collide(move_vec * MOVE_SPEED * delta)
	if is_in_river:
		move_and_slide(Vector2.RIGHT * river.PUSH_POWER)
	

func _on_River_body_entered(body):
	print("in the river")
	is_in_river = true


func _on_River_body_exited(body):
	print("out of the river")
	is_in_river = false
