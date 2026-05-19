extends Node2D

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var spawn_point: Marker2D = $Marker2D

@export var item_scene: PackedScene

var opened: bool = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player") or opened:
		return
	opened = true
	anim_sprite.play("Open")
	await anim_sprite.animation_finished
	_spawn_item()

func _spawn_item() -> void:
	if not item_scene:
		return
		
	var item := item_scene.instantiate()
	item.global_position = spawn_point.global_position
	get_parent().add_child(item)
