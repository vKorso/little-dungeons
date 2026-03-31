extends CharacterBody2D

var speed = 25

@onready var player = get_node("/root/Level1/Player")
@onready var animation = $AnimationPlayer

func _physics_process(_delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction * speed
	move_and_slide()
	update_animation()

func update_animation():
	if velocity.length() > 0:
		if abs(velocity.x) > abs(velocity.y):
			if velocity.x > 0:
				animation.play("RunRight")
			else:
				animation.play("RunLeft")
		else:
			if velocity.y > 0:
				animation.play("RunDown")
			else:
				animation.play("RunUp")
	else:
		animation.stop()
