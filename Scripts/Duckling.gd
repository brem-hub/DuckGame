extends KinematicBody2D


#Distance around ducklings 
export var DISTANCE : int

#Root - Scene
onready var root = get_tree().get_root().get_child(0)

#Duck - Player
onready var mother = root.get_node("Player")

#Tween for Interpolation
var timeTween : Tween

#Array of all ducklings
var ducklings = []


const diff = 40


var pointing= {
	1:  Vector2.UP,
	3:  Vector2.DOWN,
	5:  Vector2.LEFT,
	9:  Vector2.RIGHT,
	8: Vector2(diff, diff),
	12:  Vector2(-diff, diff),
	10:  Vector2(-diff, -diff),
	6: Vector2(diff, -diff),
}

func _ready():
	timeTween = Tween.new()
	add_child(timeTween)

func _physics_process(delta):
	if mother != null:
#		print(self.get_global_position().distance_to(mother.get_global_position()))
		# if self.get_global_position().distance_to(mother.get_global_position() + Vector2(0, diff)) - will make ducklings jump behind
		if self.get_global_position().distance_to(mother.get_global_position()) > DISTANCE:
			var correct_vector : Vector2
			if mother.moving_side in pointing.keys():
				correct_vector = pointing[mother.moving_side]
			else:
				correct_vector = Vector2(0, 0)
			timeTween.interpolate_property(self, "position", get_position(), mother.get_position() + correct_vector, 1.0, Tween.TRANS_BACK, Tween.EASE_OUT)
			timeTween.start()
			print(mother.moving_side)
#		timeTween.stop_all()
			
