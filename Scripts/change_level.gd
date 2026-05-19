extends Area2D

@export_file("*.tscn") var next_scene: String

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		change_level()

func change_level() -> void:
	if next_scene != "":
		LevelTransition.change_scene(next_scene)
	else:
		return
