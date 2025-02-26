extends CanvasLayer

func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://bgMap/bg_map.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
