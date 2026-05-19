extends Node

var zombies_killed: int = 0
var skeleton_killed: int = 0
var skeleton_boss_killed: int = 0
var killed_total: int = 0

func add_kill_zombie():
	zombies_killed += 1
	killed_total += 1

func add_kill_skeleton():
	skeleton_killed += 1
	killed_total += 1


func add_kill_skeleton_boss():
	skeleton_boss_killed += 1
	killed_total += 1
