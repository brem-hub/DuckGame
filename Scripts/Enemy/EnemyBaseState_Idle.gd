extends Node

onready var enemy = get_parent().get_parent()
onready var state_machine = get_parent()

func _enter():
	pass

func _run(var delta):
	pass

func _exit():
	pass


func _on_Timer_timeout():
	if enemy.player != null:
		state_machine._change_state("charge")
