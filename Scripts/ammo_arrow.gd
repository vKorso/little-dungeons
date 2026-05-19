extends Area2D

@export var explosion_scene: PackedScene

## Velocidad del proyectil
@export var speed: float = 200
## Tiempo de vida del proyectil
@export var lifetime: float = 5.0
## Daño del proyectil
@export var damage: float = 1.0

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage)
		_explosion()
		return

	if body.is_in_group("Walls") or body.is_in_group("Objects") or "Door" in body.name:
		_explosion()

func _explosion():
	var explosion = explosion_scene.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()
