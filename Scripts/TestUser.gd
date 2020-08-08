extends KinematicBody2D

onready var root = get_tree().get_root().get_child(0)
onready var follower = root.get_node("Follower")
var move_speed = 100
var arr = PoolVector2Array()
var points = PoolVector2Array()
func _physics_process(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_up"):
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		move_vec.y += 1
	move_vec.x += 1
	move_and_collide(move_vec * move_speed * delta)
#	arr.append(global_position)
#	follower.path = arr
		
