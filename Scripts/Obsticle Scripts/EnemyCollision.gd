extends Area2D

export var has_parent = false
var hit = false #The enemy has collided

func _physics_process(delta):
	#This is temperary
	if hit:
		#Slowly lowers the alpha of the sprite
		$Sprite.modulate.a = move_toward($Sprite.modulate.a, 0, delta)
		if $Sprite.modulate.a == 0:
			#Cleanly deletes the enemy
			if has_parent:
				get_parent().queue_free()
			else:
				queue_free()

func _on_BaseEnemy_body_entered(body):
	if body.name == "Player":
		#Makes the player take damage
		body._take_damage()
		hit = true
