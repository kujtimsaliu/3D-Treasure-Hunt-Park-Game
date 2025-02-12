extends Node
@onready var label = $Label
@onready var coins_label = $CoinsLabel
@onready var restart_button = $GameOverPanel/RestartButton  # Add this line
var game_manager: Node

func _ready() -> void:
	game_manager = get_tree().get_first_node_in_group("game_manager")
	if game_manager:
		game_manager.game_over.connect(_on_game_over)
	$GameOverPanel.hide()
	
	# Connect the restart button signal
	restart_button.pressed.connect(_on_restart_pressed)

func _process(delta: float) -> void:
	if game_manager:
		var minutes = floor(game_manager.time_remaining / 60)
		var seconds = int(game_manager.time_remaining) % 60
		label.text = "%02d:%02d" % [minutes, seconds]
		coins_label.text = "Coins: %d/%d" % [game_manager.collected_coins, game_manager.total_coins]

func _on_game_over(win: bool) -> void:
	$GameOverPanel.show()
	$GameOverPanel/Label.text = "You Won!" if win else "Time's Up!"

func _on_restart_pressed() -> void:
	game_manager.restart_game()
	$GameOverPanel.hide()  # Hide the panel when restarting
