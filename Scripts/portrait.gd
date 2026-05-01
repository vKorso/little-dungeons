extends VBoxContainer

func _ready() -> void:
	var player = get_node("/root/Level1/Player")
	player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed(new_health):
	$Control/LifeText.text=str(int(new_health))
