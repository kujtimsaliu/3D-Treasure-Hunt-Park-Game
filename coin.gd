extends Area3D

const ROT_SPEED = 5

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	rotate_y(deg_to_rad(ROT_SPEED))

func _on_body_entered(body: Node3D) -> void:
	if body.has_method("collect_coin"):
		body.collect_coin()
		var game_manager = get_tree().get_first_node_in_group("game_manager")
		if game_manager:
			game_manager.collect_coin()
		queue_free()
