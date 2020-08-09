extends Button

export var scene_path = ""

func _on_pressed():
	get_tree().paused = false
	
	if get_tree().get_root().get_child(1).get_node("YSort") != null:
		if get_tree().get_root().get_child(1).get_node("YSort").get_node("Player"):
			var sounds = get_tree().get_root().get_child(1).get_node("YSort").get_node("Player").get_node("Sounds")
			var count = sounds.get_child_count()
			for i in range(1, count):
				sounds.get_child(i).stop()
				print("stopped: ", sounds.get_child(i).get_name())
			$"/root/ThemeMusic".play()
	get_tree().change_scene(scene_path)
