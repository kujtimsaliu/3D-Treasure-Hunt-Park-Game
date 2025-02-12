extends Node
signal game_over(win: bool)

var total_coins := 12
var collected_coins := 0
var time_remaining := 120.0  # 2 minutes
var game_active := true

func _ready() -> void:
	add_to_group("game_manager")

func _process(delta: float) -> void:
	if game_active:
		time_remaining -= delta
		if time_remaining <= 0:
			game_over.emit(false)
			game_active = false

func collect_coin() -> void:
	collected_coins += 1
	if collected_coins >= total_coins:
		game_over.emit(true)
		game_active = false

func restart_game() -> void:
	collected_coins = 0
	time_remaining = 120.0
	game_active = true
	# Reload the current scene
	get_tree().reload_current_scene()
