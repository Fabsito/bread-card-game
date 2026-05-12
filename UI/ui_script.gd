extends Control

# --- Constants for easy balancing ---
const LOW_CARD_THRESHOLD = 2
const HIGH_CARD_THRESHOLD = 3
const COLOR_DANGER = "ff4545" # Red
const COLOR_FULL = "45ff45"   # Green
const COLOR_NORMAL = "ffffff" # White
# --- Node References ---
@onready var card_manager = $"../card_manager"
@onready var player: Node2D = $"../player"
@onready var game_loop = $"../game_loop"
@onready var container: Control = $VBoxContainer
@onready var health_bar: Node = $VBoxContainer/health_bar/ProgressBar
@onready var health_text: Label = $VBoxContainer/health_bar/TextEdit
var enemy_health_bar: ProgressBar
var enemy_health_text: Label
@onready var cards_left: Node = $VBoxContainer/cards_left
@onready var energy_left: Node = $VBoxContainer/energy_left
@onready var enemy
@onready var end_turn: Button = $end_turn
# --- Player references --- 




func _ready() -> void:
	enemy = get_tree().get_first_node_in_group("enemy")
	enemy_health_bar = $VBoxContainer/enemy_health_bar/ProgressBar
	enemy_health_text = $VBoxContainer/enemy_health_bar/TextEdit
	
	health_bar.max_value = player.max_health
	health_bar.value = player.current_health
	enemy_health_bar.max_value = enemy.max_health
	enemy_health_bar.value = enemy.current_health 
	# resto igual
	cards_left.pivot_offset = cards_left.size / 2
	cards_left.bbcode_enabled = true
	if card_manager:
		card_manager.child_entered_tree.connect(_on_hand_changed)
		card_manager.child_exiting_tree.connect(_on_hand_changed)
	_update_counter_display()
	_update_energy_display()

func _on_hand_changed(_node: Node) -> void:
	_update_counter_display.call_deferred()

func _update_counter_display() -> void:
	var hand_size = card_manager.get_child_count()
	var display_color = _get_color_for_size(hand_size)
	cards_left.text = "Cards left: [color=#%s]%d[/color]" % [display_color, hand_size]
	_play_pop_animation()

func _update_energy_display():
	var energy = player.energy
	var display_color = _get_color_for_size(energy)
	energy_left.text = "Energy : [color=#%s]%d[/color]" % [display_color, energy]

func _get_color_for_size(size: int) -> String:
	if size <= LOW_CARD_THRESHOLD:
		return COLOR_DANGER
	elif size >= HIGH_CARD_THRESHOLD:
		return COLOR_FULL
	return COLOR_NORMAL

# --- Visual Effects ---
func _play_pop_animation() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	cards_left.scale = Vector2(0.7, 0.7)
	tween.tween_property(cards_left, "scale", Vector2(1.0, 1.0), 0.2)
# --- buttons ---
# En el script de tu UI

func update_ui() -> void:
	health_bar.max_value = player.max_health
	health_bar.value = player.current_health
	health_text.text = "%d/%d" % [player.current_health, player.max_health]
	enemy_health_bar.value = enemy.current_health      # ← agregar
	enemy_health_text.text = "%d/%d" % [enemy.current_health, enemy.max_health]  # ← agregar
	_update_energy_display()

func _on_end_turn_pressed() -> void:
	game_loop.end_player_turn()

func _on_quit_pressed() -> void:
	get_tree().quit()
