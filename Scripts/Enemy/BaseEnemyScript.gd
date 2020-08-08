extends KinematicBody2D

export var start_stat = "wait"
export var agro = "follow"
export var speed = 80
export var target_range = [Vector2(), Vector2()]
var direction = Vector2.RIGHT
var target = Vector2()
var player

func _physics_process(delta):
	$StateMachine._change_state($StateMachine.current_state._run(delta))


func _on_Area2D_body_entered(body):
	print(body.name)
	if body.name == "Player":
		player = body
		$StateMachine._change_state(agro)

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		player = null
