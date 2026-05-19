extends Node

var owned_weapons: Array[String] = []

func acquire(weapon_name: String):
	if weapon_name not in owned_weapons:
		owned_weapons.append(weapon_name)

func has_weapon(weapon_name: String) -> bool:
	return weapon_name in owned_weapons
