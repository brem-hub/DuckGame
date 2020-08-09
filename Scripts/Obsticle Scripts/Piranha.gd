extends KinematicBody2D

onready var root = get_tree().get_root().get_child(1)
onready var player = root.get_node("Player")
#Option to set if the pirahna roams randomly or mimics the players movement
#Will need some sort of visual difference between them though, maybe two different enemies? or just different colorations?
var follow_player = false
#The min and max y value the pirahna will patrol
export var min_max_y = [0, 0]
var velocity = Vector2(0, 1)

var played : bool
#Speed of the pirahna
var move_speed = 100
var move_speed_normal = 100

func _ready():
	played = false

func _physics_process(delta):
	#Redirects to the code that sets velocity based on if it follows the player or not
	if follow_player:
		_follow_player()
	else:
		_patrol()
	#Checks if going up or down, or if hit
	if $Area2D.hit:
		if not played:
			#TODO: Borders
			$AttackSound.pitch_scale = 1 / self.scale.x + 0.2
			print($AttackSound.pitch_scale)
			$AttackSound.play()
			played = true
		if $Area2D/Sprite.animation == "down_swim":
			$Area2D/Sprite.animation = "down_attack"
			move_and_collide(Vector2.ZERO)
		elif $Area2D/Sprite.animation == "up_swim":
			$Area2D/Sprite.animation = "up_attack"
			move_and_collide(Vector2.ZERO)
	else:
		if velocity.y > 0:
			$Area2D/Sprite.animation = "down_swim"
		else:
			$Area2D/Sprite.animation = "up_swim"
		#Checks if pausing
		if player.slow_down:
			move_speed = move_speed_normal / player.SLOW_DOWN_MULTIPLIER
		else:
			move_speed = move_speed_normal
		move_and_collide(velocity * move_speed * delta)

func _follow_player():
	#Sets velocity to either go up or down, based on players position.
	velocity = Vector2()
	if player != null:
		if player.position.y < position.y:
			velocity.y -= 1
		if player.position.y > position.y:
			velocity.y += 1
	else:
		print("Player not found (pirahna)")
		player = root.get_node("Player")

func _patrol():
	#When you go too high or to low, flip directions
	if position.y < min_max_y[0] || position.y > min_max_y[1]:
		velocity.y = -velocity.y
