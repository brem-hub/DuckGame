extends KinematicBody2D

var speed = 100
var direction = Vector2.RIGHT

func _physics_process(delta):
	$StateMachine.current_state._run(delta)
