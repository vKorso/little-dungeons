extends Control

func _ready() -> void:
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String):
	if anim_name == "Scroll":
		LevelTransition.change_scene("res://Scenes/Levels/LevelIntro.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		LevelTransition.change_scene("res://Scenes/Levels/LevelIntro.tscn")
