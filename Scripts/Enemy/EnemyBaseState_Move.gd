extends Node

onready var enemy = get_parent().get_parent()
var target_margin = 0
var last_delta = 0

func _enter():
	enemy.target = Vector2(rand_range(enemy.target_range[0].x, enemy.target_range[1].x), rand_range(enemy.target_range[0].y, enemy.target_range[1].y))

func _run(var delta):
	last_delta = delta
	_move_direction()
	enemy.move_and_slide(enemy.direction * enemy.speed)
	if _is_on_target():
		return "wait"

func _exit():
	enemy.move_and_slide(Vector2.ZERO)

func _move_direction():
	enemy.direction = _get_cardinal(rad2deg(atan2(enemy.position.y - enemy.target.y, enemy.position.x - enemy.target.x)) - 90)
	enemy.direction = enemy.direction.normalized()

func _get_cardinal(var angle):
	while angle > 360:
		angle -= 360
	while angle < 0:
		angle += 360
	var directions = [Vector2(0, -1), Vector2(1, -1), Vector2(1, 0), Vector2(1, 1), Vector2(0, 1), Vector2(-1, 1), Vector2(-1, 0), Vector2(-1, -1)]
	return directions[int(round(angle/45)) % 8]

func _is_on_target():
	target_margin = last_delta * enemy.speed * 2
	return enemy.position.x > enemy.target.x - target_margin && enemy.position.x < enemy.target.x + target_margin && enemy.position.y > enemy.target.y - target_margin && enemy.position.y < enemy.target.y + target_margin
