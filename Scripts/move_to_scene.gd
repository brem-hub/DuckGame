extends Button

export var scene_path = ""

func _on_pressed():
	get_tree().change_scene(scene_path)
