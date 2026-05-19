extends Control

func _ready() -> void:
	pass # Replace with function body.

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		pause_or_unpause()

func pause_or_unpause():
	if get_tree().paused == true:
		hide()
		$"../PauseButton/PauseButton".show()
		get_tree().paused = false
	elif get_tree().paused == false:
		show()
		$"../PauseButton/PauseButton".hide()
		get_tree().paused = true

func _on_pause_texture_button_pressed() -> void:
	pause_or_unpause()
	
func _on_resume_button_pressed() -> void:
	pause_or_unpause()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	LevelTransition.change_scene("res://Scenes/menu.tscn")
