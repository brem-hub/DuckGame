extends Node


export var NUMBER_OF_DUCKS : int

export var OFFSET_BETWEEN_DUCKLINGS : int
onready var duckling_prefub = preload("res://Nodes/Duckling.tscn")

onready var root = get_tree().get_root().get_child(0)
onready var mother = root.get_node("Player")
onready var river = root.get_node("River")
onready var nav2d = root.get_node("Navigation2D")

var ducklings : Array

func spawn_ducklings():
	for i in range(NUMBER_OF_DUCKS):
		var newDuck = duckling_prefub.instance()
		var newPos = Vector2(mother.global_position.x - OFFSET_BETWEEN_DUCKLINGS * (i + 1), mother.global_position.y)
		#print(newPos)
		newDuck.set_position(newPos)
		self.add_child(newDuck)
		ducklings.append(newDuck)
		
func _ready():
	spawn_ducklings()
	
#Each duckling gets it`s own path. The first one follows the duck, the others each other.
func _process(delta):
	#Process the first duckling that follows the Duck
	var new_path = nav2d.get_simple_path(ducklings[0].global_position, mother.global_position)
	ducklings[0].path = new_path
	#Process all the other ducks
	for i in range(1, ducklings.size()):
		new_path = nav2d.get_simple_path(ducklings[i].global_position, ducklings[i-1].global_position)
		ducklings[i].path = new_path
