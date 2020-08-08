extends KinematicBody2D

onready var root = get_tree().get_root().get_child(0)
#Option to set if the pirahna roams randomly or mimics the players movement
#Will need some sort of visual difference between them though, maybe two different enemies? or just different colorations?
export var follow_player = true
#The min and max y value the pirahna will patrol
export var min_max_y = [0, 0]
var player
var velocity = Vector2(0, 1)

#Speed of the player
var move_speed = 100
var move_speed_normal = 100

func _ready():
	player = root.get_node("Player")

func _physics_process(delta):
	#Redirects to the code that sets velocity based on if it follows the player or not
	if follow_player:
		_follow_player()
	else:
		_patrol()
	#Temporary. Checks if "pausing"
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
