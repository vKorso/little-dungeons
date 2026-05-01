extends Area2D

const EXPLOSION_SCENE = preload("res://Scenes/AmmoArrowExplosion.tscn")

## Velocidad de la flecha
@export var speed: float = 175
## Tiempo de vida de la flecha
@export var lifetime: float = 5.0

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage()
		_explosion()
		return

	if body.is_in_group("Walls") or body.is_in_group("Objects"):
		_explosion()

func _explosion():
	var explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()
