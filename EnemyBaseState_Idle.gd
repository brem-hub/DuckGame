extends Node

onready var enemy = get_parent().get_parent()

func _enter():
	print("test 1")

func _run(var delta):
	pass

func _exit():
	print("test 2")
