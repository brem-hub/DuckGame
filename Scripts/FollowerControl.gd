extends Node


onready var nav2d = get_parent().get_node("Navigation2D")
onready var follower = get_parent().get_node("Follower")
onready var user = get_parent().get_node("TestUser")
# Called when the node enters the scene tree for the first time.
func _process(delta):
	var new_path = nav2d.get_simple_path(follower.global_position, user.global_position)
	#print(new_path)
	follower.path = new_path
