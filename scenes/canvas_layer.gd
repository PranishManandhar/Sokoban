
extends CanvasLayer

@onready var score_label: RichTextLabel = $Control/VBoxContainer/MarginContainer/RichTextLabel

var score: int = 0

func _on_player_is_occupied() -> void:
	score += 1
	update_score()
	print(score)

func update_score() -> void:
	score_label.clear()
	score_label.append_text("[font_size=20][b]Score: %s[/b][/font_size]" % score)
