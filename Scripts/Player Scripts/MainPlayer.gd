extends KinematicBody2D


#Speed of the player, cannot be changed
export var MOVE_SPEED_X : int
export var MOVE_SPEED_Y : int
#Max speed of the player, cannot be changed
export var MAX_SPEED : int
#Increase of speed over time
export var INC_SPEED : int

export var MAX_HEALTH : int
export var SLOW_DOWN_STAMINA_MAX: int #How long can you slow down for
export var SLOW_DOWN_STAMINA_USE: int #How long can you slow down for
export var SLOW_DOWN_STAMINA_RECOVER: int #How long can you slow down for
export var SLOW_DOWN_MULTIPLIER = 10 #How much does everything slow down by
#Camera settings
export var camera_distance_from_player = 400
export var camera_shake_multiplier = 5
export var camera_timer = 0.5

#Nodes
onready var root = get_tree().get_root().get_child(0)
#onready var river = root.get_node("River")
onready var duckling_controller = root.get_node("DucklingManager")

#If player is in the river
#var is_in_river : bool

#Current speed, can be changed
onready var move_speed_x = MOVE_SPEED_X
onready var move_speed_y = MOVE_SPEED_Y
#Remaining health
onready var health = MAX_HEALTH
#Current stamina remaining for slow down
onready var slow_down_stamina = SLOW_DOWN_STAMINA_MAX

var moving_side : int
var slow_down = false #Is time being slowed?
var slow_down_recover = false #Ran out of slow down stamina?

var game_over_text = ["Game Over\nPro Tip: ", "Don't Die", "Don't get hit", "Use the pause (shift)", "Get Good", "random_pro_tip.exe", "Read the Pro Tips", "See what you just did. Don't do that.", "WASD / Arrow Keys / D-pad / Left-Stick for movement. Press backwards to slow down time as well as Shift / A / B", "Have more children."]

func _ready():
	#Runs at the start
	$Camera2D.distance_from_player = camera_distance_from_player
	$Camera2D.shake_multiplier = camera_shake_multiplier
	$Camera2D/Control/Timer.wait_time = camera_timer
	#Assume that we begin on the ground 
	#is_in_river = true
	moving_side = 0
	#Stamina UI Max Value
	$Camera2D/Control/Stamina.max_value = SLOW_DOWN_STAMINA_MAX

func _physics_process(delta):
	#Slow Down
	if Input.is_action_pressed("slow_down") && !slow_down_recover && slow_down_stamina != 0:
		slow_down = true
		slow_down_stamina = move_toward(slow_down_stamina, 0, delta * SLOW_DOWN_STAMINA_USE)
		if slow_down_stamina == 0:
			slow_down_recover = true
	else:
		slow_down = false
		slow_down_stamina = move_toward(slow_down_stamina, SLOW_DOWN_STAMINA_MAX, delta * SLOW_DOWN_STAMINA_RECOVER)
		if slow_down_stamina == SLOW_DOWN_STAMINA_MAX:
			slow_down_recover = false
	#Sets value of stamina bar
	$Camera2D/Control/Stamina.value = slow_down_stamina
	#Speeding Up when in the river and slowing down when is out of it.
	#TODO: If needed, if not is_in_river: move_speed = MOVE_SPEED <- slow down immediately
	move_speed_y = move_toward(move_speed_y, MAX_SPEED, INC_SPEED)
#	if is_in_river:
#		if move_speed_y < MAX_SPEED:
#			move_speed_y += river.INC_SPEED
#	if not is_in_river:
#		move_speed_y = move_toward(move_speed_y, MOVE_SPEED_Y, 2*INC_SPEED)
#		if move_speed_y > MOVE_SPEED_Y:
#			move_speed_y -= 2 * river.INC_SPEED
#		else:
#			move_speed_y = MOVE_SPEED_Y	
	var move_vec = Vector2(1, 0)
	
	if slow_down:
		move_vec.x /= SLOW_DOWN_MULTIPLIER
	
	if Input.is_action_pressed("move_up"):
		moving_side = -1
		move_vec.y -= 1
	if Input.is_action_pressed("move_down"):
		moving_side = 1
		move_vec.y += 1
	
	move_and_collide(Vector2(move_vec.x * move_speed_x, move_vec.y * move_speed_y) * delta)
#	if is_in_river:
#		move_and_slide(Vector2.RIGHT * river.PUSH_POWER)

func _take_damage():
	#Code to run when taking damage
	health -= 1
	print("Health: " + str(health))
	#Remove a duckling
	duckling_controller.kill_duckling() #rip duckling
	#Shakith the camera
	$Camera2D/Control/Timer.start()
	if health == 0:
		#game over
		$Camera2D/Control/GameOver.visible = true
		$Camera2D/Control/GameOver/text.text = game_over_text[0]
		$Camera2D/Control/GameOver/text.text += game_over_text[round(rand_range(1, game_over_text.size()-1))]
		$Camera2D._pause()

func _victory():
	#Reach the end of the map
	$Camera2D/Control/Victory.visible = true
	if health == MAX_HEALTH:
		$Camera2D/Control/Victory/text.text = "Good Ending\n"
		$Camera2D/Control/Victory/text.text += "You manage to escape to Duckmark with all of your babies. You live the rest of your duck life watching your ducklings grow up to do duck things, like eat bread and terrarize children."
	elif health != 1:
		$Camera2D/Control/Victory/text.text = "Neutral Ending\n"
		$Camera2D/Control/Victory/text.text += "You manage to escape to Duckmark with most of your babies. Although heart-broken by the lose of your little ducklings, expecially your secret favorite, Dave, you have to put on a brave face for your remaining ducklings."
	else:
		$Camera2D/Control/Victory/text.text = "Bad Ending\n"
		$Camera2D/Control/Victory/text.text += "You manage to escape to Duckmark, however your ducklings were not able to survive the trechurous journey. You fall into a great depression, forever mourning your lost ducklings. You often wonder if you were just a bit quicker, if you would have been able to save them..."
	$Camera2D.victory = true

#func _on_River_body_entered(body):
#	if body.name == "Player":
#		print("in the river")
#		is_in_river = true

#func _on_River_body_exited(body):
#	if body.name == "Player":
#		print("out of the river")
#		is_in_river = false
