extends Node2D

## Cadencia de disparo
@export var fire_rate: float = 0.1
@export var projectile_scene: PackedScene

@onready var shot_point: Marker2D = $Sprite2D/ShotPoint
@onready var anim_player: AnimationPlayer = $AnimationPlayer

var icon: Texture2D = preload("res://Assets/Weapons/bow.png")

var can_shoot: bool = true

func _shoot() -> void:
	if not can_shoot:
		return
	if not projectile_scene:
		push_error("WeaponBow: projectile_scene no está asignado en el Inspector")
		return
	
	can_shoot = false
	var projectile = projectile_scene.instantiate()
	
	projectile.global_position = shot_point.global_position
	projectile.global_rotation = shot_point.global_rotation
	get_tree().current_scene.add_child(projectile)
	
	anim_player.play("Shoot")
	Audio.play_shoot_bow()
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true

func _physics_process(_delta: float) -> void:
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("Shoot"):
		_shoot()
