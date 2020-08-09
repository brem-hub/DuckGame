extends Node

#Prefubs
onready var duckling_prefub = preload("res://Nodes/Duckling.tscn")

#Distance between ducklings
export var OFFSET_BETWEEN_DUCKLINGS : int
#Distance between the duck and the first duckling
export var OFFSET_BETWEEN_DUCK : int
#Nodes
onready var root = get_tree().get_root().get_child(0)
onready var mother = root.get_node("Player")
#onready var river = root.get_node("River")
onready var nav2d = root.get_node("Navigation2D")


onready	var NUMBER_OF_DUCKS = mother.MAX_HEALTH-1
 
var ducklings : Array

func kill_duckling():
	if ducklings.size() - 1 >= 0:
		remove_child(ducklings[ducklings.size() -1])
		ducklings.remove(ducklings.size() - 1)
	else:
		print("All the ducklings are dead - player should not have any health!")

#Spawns ducklings at the start behind the Duck and puts them into the array.
func spawn_ducklings():
	var newDuck = duckling_prefub.instance()
	var newPos = Vector2(mother.global_position.x - OFFSET_BETWEEN_DUCK, mother.global_position.y)
	newDuck.set_position(newPos)
	self.add_child(newDuck)
	ducklings.append(newDuck)
	for i in range(1, NUMBER_OF_DUCKS):
		newDuck = duckling_prefub.instance()
		newPos = Vector2(mother.global_position.x - OFFSET_BETWEEN_DUCKLINGS * (i + 1), mother.global_position.y)
		newDuck.set_position(newPos)
		self.add_child(newDuck)
		ducklings.append(newDuck)


func _ready():
	spawn_ducklings()
	
#Each duckling gets it`s own path. The first one follows the Duck, the others each other.
func _physics_process(delta):
	
	#Process the first duckling that follows the Duck
	if ducklings.empty():
		print("Error, no ducklings")
		return
	var new_path = nav2d.get_simple_path(ducklings[0].global_position, Vector2(mother.global_position.x - OFFSET_BETWEEN_DUCK, mother.global_position.y))
	ducklings[0].path = new_path
	
	#Process all the other ducks
	for i in range(1, ducklings.size()):
		new_path = nav2d.get_simple_path(ducklings[i].global_position, Vector2(ducklings[i-1].global_position.x - OFFSET_BETWEEN_DUCKLINGS,ducklings[i-1].global_position.y))
		ducklings[i].path = new_path
