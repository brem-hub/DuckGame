extends "res://Scripts/Enemy/EnemyBaseState_Move.gd"

onready var state_machine = get_parent()

func _enter():
	$Timer.wait_time = rand_range(1, 5)
	$Timer.start()

func _run(var delta):
	if enemy.player == null:	return "move"
	enemy.target = enemy.player.position
	last_delta = delta
	_move_direction()
	enemy.move_and_slide(enemy.direction * (enemy.speed + 10))

func _on_Timer_timeout():
	enemy.player = null
