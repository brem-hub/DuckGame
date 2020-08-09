extends Area2D

#Add this script to the area2d at the end of the level

func _on_Victory_body_entered(body):
	if body.name == "Player":
		body._victory()

