extends Node2D

func shoot():
	const Bullet = preload("res://Scenes/AmmoArrow.tscn")
	var new_bullet = Bullet.instantiate()
	new_bullet.global_position = $Sprite2D/ShotPoint.global_position
	new_bullet.global_rotation = $Sprite2D/ShotPoint.global_rotation
	get_tree().current_scene.add_child(new_bullet)

func _physics_process(_delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).angle()
	rotation = direction
	
	if Input.is_action_just_pressed("Shoot"):
		shoot()
