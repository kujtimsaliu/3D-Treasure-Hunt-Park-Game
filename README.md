# 3D Treasure Hunt Park Game
## Technical Documentation

if you dont mind waiting a bit to load:
https://kujtimsaliu.itch.io/3d-treasure-hunt-park-game

### Project Links
- **GitHub Repository**: [GitHub repository](https://github.com/kujtimsaliu/3D-Treasure-Hunt-Park-Game)
- **Gameplay Demo**: [YouTube video](https://youtu.be/J0u-Tbjg2cg?si=FhwWCn-lpnOhU0Gb)

### Game Overview
A 3D treasure hunt game where players explore a park environment collecting coins within a time limit. The game features a dynamic coin collection system, time management, and victory/defeat conditions.

### Technical Implementation

#### Core Game Systems

##### 1. Coin System
The coin collection system is implemented through an Area3D node with rotation and collection mechanics:

```gdscript
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
```

Key features:
- Constant rotation for visual appeal
- Collision detection with player
- Automatic removal upon collection
- Game manager notification

##### 2. Game Manager
The game manager handles core game logic and state:

```gdscript
extends Node
signal game_over(win: bool)

var total_coins := 12
var collected_coins := 0
var time_remaining := 140.0  # 2 minutes and 20 seconds
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
    get_tree().reload_current_scene()
```

Features:
- Time management
- Coin collection tracking
- Win/lose condition monitoring
- Game restart functionality

##### 3. UI System
The UI system manages the game's interface:

```gdscript
extends Node

@onready var label = $Label
@onready var coins_label = $CoinsLabel
@onready var restart_button = $GameOverPanel/RestartButton

func _ready() -> void:
    game_manager = get_tree().get_first_node_in_group("game_manager")
    if game_manager:
        game_manager.game_over.connect(_on_game_over)
    $GameOverPanel.hide()
    restart_button.pressed.connect(_on_restart_pressed)

func _process(delta: float) -> void:
    if game_manager:
        var minutes = floor(game_manager.time_remaining / 60)
        var seconds = int(game_manager.time_remaining) % 60
        label.text = "%02d:%02d" % [minutes, seconds]
        coins_label.text = "Coins: %d/%d" % [
            game_manager.collected_coins, 
            game_manager.total_coins
        ]
```

Features:
- Real-time timer display
- Coin collection counter
- Victory/defeat screens
- Restart functionality

##### 4. Collectible Spawning System
The spawning system handles coin placement:

```gdscript
extends Node3D

@export var collectible_scene: PackedScene
@export var num_items: int = 10

func _ready():
    spawn_collectibles()

func spawn_collectibles():
    var spawn_points = get_tree().get_nodes_in_group("spawn_points")
    spawn_points.shuffle()
    for i in range(min(num_items, spawn_points.size())):
        var collectible = collectible_scene.instantiate()
        add_child(collectible)
        collectible.position = spawn_points[i].global_position
```

Features:
- Random spawn point selection
- Dynamic collectible instantiation
- Configurable number of items

### Game States

1. **Active Gameplay**
   - Timer counting down
   - Coin collection active
   - UI displaying current status

2. **Victory State**
   - Triggered when all coins are collected
   - Displays "You Won!" message
   - Offers restart option

3. **Defeat State**
   - Triggered when time runs out
   - Displays "Time's Up!" message
   - Offers restart option

### User Interface Elements

1. **During Gameplay**
   - Timer display (MM:SS format)
   - Coin counter (collected/total)
   - Player status indicators

2. **Game Over Panel**
   - Victory/defeat message
   - Restart button
   - Final score display

### Environment Setup

The game environment consists of:
- Designated spawn points for collectibles
- Park elements and obstacles
- Collision areas for coin collection
- Player movement boundaries

### Installation Instructions

1. Clone the repository
2. Open project in Godot Engine
3. Ensure all assets are properly imported
4. Run the game scene

### Controls
- WASD/Arrow Keys: Player movement
- Mouse: Camera control
- Spacebar: Jump
- ESC: Pause game

### Performance Considerations

1. **Optimization Techniques**
   - Efficient coin rotation system
   - Smart spawn point management
   - Scene reloading for game restart

2. **Memory Management**
   - Proper cleanup of collected coins
   - Scene management during restart
   - Resource preloading

### Debug Features
- Coin collection verification
- Time management system
- Spawn point validation
- Collision detection monitoring

### Future Enhancements
1. Additional collectible types
2. Multiple levels
3. High score system
4. Sound effects and music
5. Particle effects for coin collection

### Known Issues and Solutions
1. Coin Collection
   - Issue: Multiple collection triggers
   - Solution: Implemented single-collection verification

2. Timer Accuracy
   - Issue: Frame-dependent timing
   - Solution: Delta-time based countdown

### Version History
- v1.0.0: Initial release

### Support
For technical support or questions:
- Email: kujtimsaliu011@gmail.com
- GitHub Issues: [Repository Issues](https://github.com/kujtimsaliu/3D-Treasure-Hunt-Park-Game/issues)

---
© 2025 [Kujtim Saliu]. All rights reserved.
