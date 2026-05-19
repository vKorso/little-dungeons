extends Node2D

var opened = false

var spawners_done: int = 0
var total_spawners: int = 0

func _ready() -> void:
	var spawners = get_tree().get_nodes_in_group("Spawners")
	total_spawners = spawners.size()
	for s in spawners:
		s.connect("spawner_completed", Callable(self, "_on_spawner_completed"))
		
	$DoorRight.animation_finished.connect(_on_animation_finished)
	$DoorLeft.animation_finished.connect(_on_animation_finished)
	$DoorRight/DoorRightStaticBody2D/CollisionShape2D.disabled = false
	$DoorLeft/DoorLeftStaticBody2D2/CollisionShape2D.disabled = false

func open_door():
	opened = true
	$DoorRight.play("Open")
	$DoorLeft.play("Open")

func _on_animation_finished():
	if $DoorRight.animation == "Open":
		$DoorRight/DoorRightStaticBody2D/CollisionShape2D.disabled = true
	if $DoorLeft.animation == "Open":
		$DoorLeft/DoorLeftStaticBody2D2/CollisionShape2D.disabled = true

func _on_spawner_completed():
	spawners_done += 1
	if spawners_done >= total_spawners:
		open_door()
