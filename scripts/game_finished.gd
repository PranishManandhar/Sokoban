extends CanvasLayer

func _on_playagains_pressed() -> void:
	get_tree().reload_current_scene()


func _on_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/level_selector.tscn"))
