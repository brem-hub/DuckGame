extends KinematicBody2D

#Unchangable speed var
export var SPEED : int
#Ucnhangable max_speed
export var MAX_SPEED : int

#Changable speed var
onready var speed = SPEED

onready var mother = get_tree().get_root().get_child(0).get_node("Player")
onready var river = get_tree().get_root().get_child(0).get_node("River")
#Path to follow
var path  : = PoolVector2Array() setget set_path

func _physics_process(delta):
	if mother.is_in_river:
		if speed < MAX_SPEED:
			speed += river.INC_SPEED
	else:
		if speed > SPEED:
			speed -= 2 * river.INC_SPEED
		elif speed < SPEED:
			speed = SPEED
			
	var move_distance = speed * delta
	move_along_path(move_distance, delta)
	#print("DUCKLING: ", speed)

func move_along_path(distance, delta):
	var start_point = position
	for i in range(path.size()):
		var distance_next = start_point.distance_to(path[0])
		if distance <= distance_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance /1)
			break
		elif distance < 0.0:
			position = path[0]
			set_process(false)
			break
		distance -= distance_next
		start_point = path[0]
		path.remove(0)
	
func set_path(value : PoolVector2Array) -> void:
	path = value
	if value.size() == 0:
		return
	set_process(true)
