extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func change_scene(target_scene_path: String):
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().change_scene_to_file(target_scene_path)
	animation_player.play_backwards("fade")
