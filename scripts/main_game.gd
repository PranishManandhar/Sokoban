extends Node2D

@onready var end_screen:CanvasLayer

func _ready() -> void:
	end_screen = get_node("end_Screen")

func _on_player_level_completed() -> void:
	end_screen.visible = true
	print("Level Completed")
