extends Control

func _ready() -> void:
	Audio.play_music_credits()
	$AnimationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String):
	if anim_name == "Scroll":
		Audio.stop_music_credits()
		Audio.play_music()
		LevelTransition.change_scene("res://Scenes/menu.tscn")
