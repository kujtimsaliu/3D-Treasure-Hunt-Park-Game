extends Node3D

@export var collectible_scene: PackedScene
@export var num_items: int = 10

func _ready():
	spawn_collectibles()

func spawn_collectibles():
	var spawn_points = get_tree().get_nodes_in_group("spawn_points")
	spawn_points.shuffle()  # Randomize the order of spawn points

	for i in range(min(num_items, spawn_points.size())):
		var collectible = collectible_scene.instantiate()
		add_child(collectible)
		collectible.position = spawn_points[i].global_position  # Use the spawn point's position
