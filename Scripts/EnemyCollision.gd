extends Area2D

func _ready():
	pass

func _on_BaseEnemy_body_entered(body):
	if body.name == "Player":
		body._take_damage()
