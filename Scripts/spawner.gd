extends Area2D

## Lista de escenas de enemigos a spawnear (se deben añadir en el Inspector)
@export var enemy_scenes: Array[PackedScene] = []
## Tiempo entre cada spawn
@export var spawn_interval: float = 2.0
## Total de enemigos spawneados
@export var max_total_spawned: int = 5

var total_spawned: int = 0
var polygon: PackedVector2Array
var triangles: PackedInt32Array
var is_spawning: bool = false
var enemies_alive = 0

func _ready() -> void:
	polygon = $CollisionPolygon2D.polygon
	triangles = Geometry2D.triangulate_polygon(polygon)
	var existing_enemies = get_tree().get_nodes_in_group("Enemies")
	for e in existing_enemies:
		e.connect("enemy_died", Callable(self,"_on_enemy_died"))
		enemies_alive+=1
	_start_spawn_loop()

func _start_spawn_loop() -> void:
	if is_spawning:
		return
	is_spawning = true
	_spawn_loop()


func _spawn_loop() -> void:
	while total_spawned < max_total_spawned:
		await get_tree().create_timer(spawn_interval).timeout
		_spawn_enemy()
		total_spawned += 1
		enemies_alive+=1
	is_spawning = false


func _spawn_enemy() -> void:
	if enemy_scenes.is_empty():
		return

	var scene: PackedScene = enemy_scenes[randi() % enemy_scenes.size()]
	var enemy: Node2D = scene.instantiate()
	enemy.position = _get_random_point_in_polygon()
	enemy.connect("enemy_died", Callable(self,"_on_enemy_died"))
	get_parent().add_child(enemy)

func _on_enemy_died():
	enemies_alive-=1
	if enemies_alive <= 0 and total_spawned >= max_total_spawned:
		next_level()

func next_level():
	#var current_scene_file = get_tree().current_scene.scene_file_path
	#var next_level_num = current_scene_file.to_int()+1
	#var next_level_path = "res://Scenes/Level" + str(next_level_num)+".tscn"
	#if ResourceLoader.exists(next_level_path):
	#	get_tree().change_scene_to_file(next_level_path)
	#else:
	#	print()
	get_tree().change_scene_to_file("res://Scenes/menu.tscn")
	

func _get_random_point_in_polygon() -> Vector2:
	@warning_ignore("integer_division") 
	var count := triangles.size() / 3
	var index := randi() % count * 3
	
	var p1 := polygon[triangles[index]]
	var p2 := polygon[triangles[index + 1]]
	var p3 := polygon[triangles[index + 2]]

	var r1 := sqrt(randf())
	var r2 := randf()
	
	var point := (1.0 - r1) * p1 + (r1 * (1.0 - r2)) * p2 + (r1 * r2) * p3

	return $CollisionPolygon2D.to_global(point)
