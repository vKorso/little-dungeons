extends VBoxContainer

func _ready() -> void:
	await get_tree().process_frame
	var player = get_tree().get_first_node_in_group("Player")
	
	if player:
		player.health_changed.connect(_on_player_health_changed)		

func _on_player_health_changed(new_health):
	$Control/LifeText.text=str(int(new_health))
