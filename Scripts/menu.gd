extends Control

func _on_button_pressed() -> void:
	LevelTransition.change_scene("res://Scenes/Intro.tscn")

func _on_button_2_pressed() -> void:
	LevelTransition.change_scene("res://Scenes/Levels/LevelInfinite.tscn")
