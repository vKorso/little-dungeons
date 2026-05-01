extends CharacterBody2D

## Velocidad del zombie
@export var speed: float = 25
## Vida del zombie
@export var health: float = 3

@onready var player = get_node("/root/Level1/Player")
@onready var animation = $AnimatedSprite2D

var is_hurt: bool = false

signal enemy_died

func _physics_process(_delta: float) -> void:
	if is_hurt:
		return

	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	_update_animation()

func take_damage():
	if is_hurt:
		return
	
	is_hurt = true
	
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			animation.play("HurtRight" if velocity.x > 0 else "HurtLeft")
		else:
			animation.play("HurtDown" if velocity.y > 0 else "HurtUp")
	#else:
		#animation.stop()
		
	#velocity = Vector2.ZERO # Se detiene tras recibir daño
	health-=1
	await animation.animation_finished
	
	if health <= 0:
		emit_signal("enemy_died")
		queue_free()
		
	is_hurt = false

func _update_animation():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			animation.play("RunRight" if velocity.x > 0 else "RunLeft")
		else:
			animation.play("RunDown" if velocity.y > 0 else "RunUp")
	else:
		animation.stop()
