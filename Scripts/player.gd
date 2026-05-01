extends CharacterBody2D

## Velocidad del personaje
@export var speed: float = 125
## Vida del personaje
@export var health: float = 100
## Tiempo para recuperar el control del personaje rápido tras el daño
@export var player_dmg_time: float = 0.3
## Tiempo para recuperarse tras recibir daño (player_dmg_time + player_dmg_recovery)
@export var player_dmg_recovery: float = 0.3

@onready var animation = $AnimatedSprite2D

var last_dir = "Down"
var is_hurt: bool = false
var can_take_damage: bool = true

signal health_changed(new_health)

func _physics_process(_delta: float) -> void:
	var dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	velocity = dir * speed if not is_hurt else Vector2.ZERO
	
	_health_bar()
	move_and_slide()
	
	var mouse_pos = get_local_mouse_position()
	if not is_hurt:
		if abs(mouse_pos.x) > abs(mouse_pos.y):
			last_dir = "Right" if mouse_pos.x > 0 else "Left"
		else:
			last_dir = "Down" if mouse_pos.y > 0 else "Up"
			
		var state = "Walk" if dir.length() > 0 else "Idle"
		animation.play(state + last_dir)
	
	if can_take_damage:
		for body in $DamageArea.get_overlapping_bodies():
			if body.is_in_group("Enemies"):
				take_damage(5)
				break

func _health_bar():
	$ProgressBar.value = health
	
	var fill_style = $ProgressBar.get("theme_override_styles/fill") as StyleBoxFlat
	
	if health < 30:
		fill_style.bg_color = Color.RED
	elif health < 60:
		fill_style.bg_color = Color.ORANGE
	else:
		fill_style.bg_color = Color.GREEN
	

func take_damage(amount):
	if not can_take_damage: return
	
	can_take_damage = false	# Bloquea daño futuro
	is_hurt = true			# Bloquea movimiento/animación
	
	health-=amount
	emit_signal("health_changed", health)
	animation.play("Hurt" + last_dir)
	
	if health <= 0:
		get_tree().reload_current_scene()
		return
		
	# Recuperar el control del personaje rápido según variable player_dmg_recovery
	await get_tree().create_timer(player_dmg_time).timeout
	is_hurt = false
	
	# Puede recibir daño tras player_dmg_time + player_dmg_recovery
	await get_tree().create_timer(player_dmg_recovery).timeout
	can_take_damage = true
