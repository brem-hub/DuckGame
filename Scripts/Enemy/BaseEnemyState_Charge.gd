extends "res://Scripts/Enemy/EnemyBaseState_Move.gd"

onready var state_machine = get_parent()

func _enter():
	enemy.target = enemy.player.position
	_move_direction()
	$Timer.wait_time = rand_range(1, 5)
	$Timer.start()

func _run(var delta):
	if enemy.player == null:	return "idle"
	last_delta = delta
	enemy.move_and_slide(enemy.direction * enemy.speed)

func _on_Timer_timeout():
	state_machine._change_state("idle")
