extends Node2D

func _on_level_1_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/Levels/level_1.tscn"))


func _on_level_2_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/Levels/level_2.tscn"))

func _on_level_3_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/Levels/level_3.tscn"))

func _on_level_4_pressed() -> void:
	get_tree().change_scene_to_packed(load("res://scenes/Levels/level_4.tscn"))


func _on_button_pressed() -> void:
	get_tree().quit()
