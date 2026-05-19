extends CharacterBody2D

## Velocidad del boss
@export var speed: float = 10
## Vida del boss
@export var max_health: float = 100
var health := max_health

var player: Node2D
@onready var animation = $AnimatedSprite2D

var is_hurt: bool = false

@export var bullet_scene: PackedScene
@export var bullets_per_wave := 12
@export var fire_rate := 0.15
@export var wave_interval := 2.00
@export var shots_per_wave := 3
var firing := false
@onready var timer = $Timer

@export var laser_fire_rate := 0.10
@export var laser_rotation_speed := 180.0
@export var laser_lines := 3
@export var laser_angle_gap := 90.0
var laser_active := false
var laser_angle := 0.0
var laser_timer := 0.0


var center_position: Vector2

var phase := 1

signal enemy_boss_died
signal enemy_died

func _ready():
	Audio.play_music_boss()
	center_position = global_position
	player = get_tree().get_first_node_in_group("Player")
	_update_health_bar()
	timer.timeout.connect(_on_timer_timeout)
	timer.wait_time = wave_interval
	timer.start()

func _physics_process(_delta: float) -> void:
	if is_hurt or not player:
		return
	
	_update_animation()
	match phase:
		1:
			move_position(player.global_position)
		2:
			move_position(player.global_position)
		3:
			move_position(center_position)
		4:
			move_position(player.global_position)
		5:
			move_position(center_position)
			if laser_active: update_laser_attack(_delta)

func update_laser_attack(delta):
	if not laser_active:
		return
	
	laser_angle = fposmod(laser_angle + deg_to_rad(laser_rotation_speed)*delta, TAU)
	laser_timer -= delta
	if laser_timer <= 0:
		fire_laser_barrage()
		laser_timer = laser_fire_rate

func fire_laser_barrage():
	for i in range(laser_lines):
		var angle = laser_angle-deg_to_rad(i*laser_angle_gap)
		var bullet = bullet_scene.instantiate()
		bullet.global_position = global_position
		bullet.direction = Vector2.RIGHT.rotated(angle)
		bullet.rotation = angle
		get_parent().add_child(bullet)

func move_position(target: Vector2):
	velocity = global_position.direction_to(target) * speed
	move_and_slide()
	
	if global_position.distance_to(target) < 5:
		global_position = target
		velocity = Vector2.ZERO
		_update_animation()
	

func take_damage(amount):
	if is_hurt:
		return
	
	is_hurt = true
	
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			animation.play("HurtRight" if velocity.x > 0 else "HurtLeft")
		else:
			animation.play("HurtDown" if velocity.y > 0 else "HurtUp")
	else:
		animation.play("HurtDown")
	
	health-=amount
	_update_health_bar()
	await animation.animation_finished
	
	if health <= 0:
		GameStats.add_kill_skeleton_boss()
		emit_signal("enemy_boss_died")
		emit_signal("enemy_died")
		LevelTransition.change_scene("res://Scenes/Credits.tscn")
		queue_free()
	check_phase()
		
	is_hurt = false

func check_phase():
	var new_phase := 1
	if health <= max_health * 0.3:
		new_phase = 5
	elif health <= max_health * 0.4:
		new_phase = 4
	elif health <= max_health * 0.7:
		new_phase = 3
	elif health <= max_health * 0.8:
		new_phase = 2
	if new_phase != phase:
		phase = new_phase
		on_phase_change()

func on_phase_change():
	match phase:
		2: # Aumenta la velocidad de motivimento y oleadas de ataque
			set_fire_params(20, 14, 0.15, 1.8, 4)
		3: # Vuelve al centro y realiza ráfagas
			set_fire_params(40, 18, 0.10, 1.5, 5)
		4: # Vuelve a perseguir
			set_fire_params(30, 14, 0.15, 1.8, 4)
		5: # Ataque en rotación
			timer.stop()
			start_laser_attack()
	
func start_laser_attack():
	laser_active = true
	laser_timer = 0
	laser_angle = 0

func set_fire_params(p_speed, p_bullets_per_wave, p_fire_rate, p_wave_interval, p_shots_per_wave):
	speed = p_speed
	bullets_per_wave = p_bullets_per_wave 
	fire_rate = p_fire_rate
	wave_interval = p_wave_interval
	shots_per_wave = p_shots_per_wave
	timer.wait_time = wave_interval
	timer.start()

func _update_animation():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			animation.play("RunRight" if velocity.x > 0 else "RunLeft")
		else:
			animation.play("RunDown" if velocity.y > 0 else "RunUp")
	else:
		animation.play("Idle")

func _update_health_bar():
	$CanvasLayer/Control/ProgressBar.value = health

func _on_timer_timeout():
	if not firing:
		fire_bullet_wave()

func fire_bullet_wave():
	firing = true
	await start_fire_wave()
	firing = false

func start_fire_wave():
	for i in range(shots_per_wave):
		spawn_circular_bullets()
		await get_tree().create_timer(fire_rate).timeout

func spawn_circular_bullets():
	var offset = randf()*TAU
	var step = TAU/bullets_per_wave
	for i in range(bullets_per_wave):
		var bullet = bullet_scene.instantiate()
		bullet.position = global_position
		bullet.direction = Vector2.RIGHT.rotated(i*step+offset)
		get_parent().add_child(bullet)
