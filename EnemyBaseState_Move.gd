extends Node

onready var enemy = get_parent().get_parent()

func _enter():
	pass

func _run(var delta):
	enemy.move_and_slide(enemy.direction * enemy.speed)

func _exit():
	pass
