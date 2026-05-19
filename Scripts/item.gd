extends Area2D

@export var weapon_name: String = "WeaponGun"
@onready var anim_player: AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.play("Spawn")
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: StringName):
	if anim_name == "Spawn":
		anim_player.play("Fly")

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player"):
		var weapons = area.get_parent().get_node("Weapons")
		if weapons:
			weapons.pickup_weapon(weapon_name)
		queue_free()
