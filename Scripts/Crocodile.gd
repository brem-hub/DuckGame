extends KinematicBody2D

onready var root = get_tree().get_root().get_child(0)
var player
var velocity = Vector2()

#Speed of the player
var move_speed = 100
var move_speed_normal = 200
var move_speed_slow = 20

func _ready():
	#Gets the player
	player = root.get_node("Player")

func _physics_process(delta):
	#Won't work later, only temp
	#This causes the enemies to slow down
	if Input.is_action_pressed("speed_up"):
		move_speed = move_speed_slow
	else:
		move_speed = move_speed_normal
	move_and_collide(velocity * move_speed * delta)

func _on_Charge_body_entered(body):
	#Check to see if the player is infront of the crocodile
	if body.name == "Player":
		velocity = Vector2(-1, 0)
