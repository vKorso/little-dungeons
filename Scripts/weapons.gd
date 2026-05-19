extends Node2D

var weapons = []
var owned_weapons = []
var current_weapon_index = 0

@onready var weapon_icon = $CanvasLayer/Control/Weapon/Control/TextureRect

func _ready() -> void:
	weapons = [$WeaponBow, $WeaponGun]

	for weapon in weapons:
		set_weapon_enabled(weapon, false)
	
	for weapon in weapons:
		if Data.has_weapon(weapon.name):
			owned_weapons.append(weapon)
	
	if owned_weapons.is_empty():
		var starting_weapon = weapons[0]
		owned_weapons.append(starting_weapon)
		Data.acquire(starting_weapon.name)
		set_weapon_enabled(starting_weapon, true)
	else:
		var current_weapon = owned_weapons[0]
		set_weapon_enabled(current_weapon, true)
	
	update_icon()

func update_icon() -> void:
	var current_weapon = owned_weapons[current_weapon_index]
	if weapon_icon and current_weapon.get("icon"):
		weapon_icon.texture = current_weapon.icon
		
func set_weapon_enabled(weapon, enabled):
	weapon.visible = enabled
	weapon.set_process(enabled)
	weapon.set_physics_process(enabled)

func equip_weapon(delta):
	if owned_weapons.size() <= 1:
		return
	
	set_weapon_enabled(owned_weapons[current_weapon_index], false)
	current_weapon_index = (current_weapon_index + delta + owned_weapons.size()) % owned_weapons.size()
	set_weapon_enabled(owned_weapons[current_weapon_index],true)
	
	update_icon()

func pickup_weapon(weapon_name: String) -> void:
	if Data.has_weapon(weapon_name):
		return
	for weapon in weapons:
		if weapon.name == weapon_name:
			Data.acquire(weapon_name)
			owned_weapons.append(weapon)
			set_weapon_enabled(weapon, false)
			update_icon()
			return

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			equip_weapon(-1)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			equip_weapon(+1)
