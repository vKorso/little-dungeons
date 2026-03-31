extends Area2D

var speed = 175

func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		body.queue_free()
	elif body.is_in_group("Walls"):
		queue_free()
