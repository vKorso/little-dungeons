extends Area2D

const EXPLOSION_SCENE = preload("res://Scenes/AmmoArrowExplosion.tscn")

## Velocidad del hueso
@export var speed: float = 120
## Tiempo de vida del hueso
@export var lifetime: float = 5.0
## Daño del hueso
@export var damage_bone: float = 5.0

var direction: Vector2 = Vector2.ZERO

func _ready():
	get_tree().create_timer(lifetime).timeout.connect(queue_free)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Walls") or body.is_in_group("Objects"):
		_explosion()

func _explosion():
	var explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		_explosion()
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(damage_bone)
