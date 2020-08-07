extends Area2D

#How strong the current is
export var PUSH_POWER : int

onready var root = get_tree().get_root().get_child(0)

#func _on_River_body_entered(body):
#	var player = root.get_node("Player")
#	if player == null:
#		print("ERROR OCCURED, CAN`T FIND PLAYER IN THE ROOT NODE")
#	if body == player:
#		print("Works")
