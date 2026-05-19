extends Node2D


@onready var boss_camera = $"../Camera2D"

func _ready() -> void:
	boss_camera.make_current()
