extends Control

@onready var label = $LabelEnemiesTotal

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	label.text = "Eliminados: %d" % GameStats.killed_total
