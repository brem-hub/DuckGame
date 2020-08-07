extends Node2D

var current_state
var current_state_string
onready var state_list = {
	"idle": $Idle,
	"move": $Move
}

func _ready():
	_change_state("idle")
	_change_state("move")

func _change_state(var new_state):
	if new_state == current_state_string:	return
	if !state_list.has(new_state):	return
	if current_state != null:
		current_state._exit()
	current_state_string = new_state
	current_state = state_list[new_state]
	current_state._enter()
