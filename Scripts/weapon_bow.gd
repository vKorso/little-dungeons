extends Node2D

const BULLET_SCENE = preload("res://Scenes/AmmoArrow.tscn")

## Cadencia de disparo
@export var fire_rate: float = 0.5

@onready var shot_point: Marker2D = $Sprite2D/ShotPoint
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var can_shoot: bool = true

func _shoot() -> void:
	if not can_shoot:
		return
	
	can_shoot = false
	
	var new_bullet = BULLET_SCENE.instantiate()

	new_bullet.global_position = shot_point.global_position
	new_bullet.global_rotation = shot_point.global_rotation
	get_tree().current_scene.add_child(new_bullet)
	
	anim_player.play("Shoot")
	Audio.play_shoot_bow()
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Shoot"):
		_shoot()
