extends Node2D

var opened = false

func _ready() -> void:
	$DoorRight.animation_finished.connect(_on_animation_finished)
	$DoorLeft.animation_finished.connect(_on_animation_finished)
	$DoorRight/DoorRightStaticBody2D2/CollisionShape2D.disabled = false
	$DoorLeft/DoorLeftStaticBody2D2/CollisionShape2D.disabled = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and not opened:
		opened = true
		$DoorRight.play("Open")
		$DoorLeft.play("Open")

func _on_animation_finished():
	if $DoorRight.animation == "Open":
		$DoorRight/DoorRightStaticBody2D/CollisionShape2D.disabled = true
		$DoorRight/DoorRightStaticBody2D2/CollisionShape2D.disabled = false
	if $DoorLeft.animation == "Open":
		$DoorLeft/DoorLeftStaticBody2D/CollisionShape2D.disabled = false
		$DoorLeft/DoorLeftStaticBody2D2/CollisionShape2D.disabled = true
