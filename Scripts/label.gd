extends Label

@onready var label = $ZombieLabel  # ajusta el nombre del nodo

func _ready() -> void:
	pass
 
func _process(delta: float) -> void:
	text = "Zombies: %d" % GameStats.zombies_killed
