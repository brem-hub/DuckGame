extends KinematicBody2D


var path  : = PoolVector2Array() setget set_path
var speed = 1


func _process(delta):
	var move_distance = speed * delta
	move_along_path(move_distance)

func move_along_path(distance):
	#print(path)
	var start_point = position
	
	for i in range(path.size()):
		var distance_next = start_point.distance_to(path[0])
		print(distance_next)
		if distance <= distance_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / 1)
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
