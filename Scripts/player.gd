extends CharacterBody2D

var speed = 125
var lastDirection = "Down"

@onready var animation = $AnimationPlayer

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * speed
	move_and_slide()
	
	if direction.length() > 0:
		if abs(direction.x) > abs(direction.y):
			lastDirection = "Right" if direction.x > 0 else "Left"
		else:
			lastDirection = "Down" if direction.y > 0 else "Up"
		animation.play("Walk" + lastDirection)
	else:
		animation.play("Idle" + lastDirection)
