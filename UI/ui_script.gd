extends Control

# --- Constants for easy balancing ---
const LOW_CARD_THRESHOLD = 2
const HIGH_CARD_THRESHOLD = 3
const COLOR_DANGER = "ff4545" # Red
const COLOR_FULL = "45ff45"   # Green
const COLOR_NORMAL = "ffffff" # White
# --- Node References ---
@onready var card_manager = $"../card_manager"
@onready var cards_left: RichTextLabel = $back_ground/VBoxContainer/cards_left
@onready var energy_left: RichTextLabel = $back_ground/VBoxContainer/energy_left
@onready var player: Node2D = $back_ground/VBoxContainer/player
@onready var health_bar: Control = $back_ground/VBoxContainer/health_bar


# --- Player references --- 



func _ready() -> void:
	health_bar.initiate_health_bar(player.max_health)
	health_bar.update_health(player.current_health,player.max_health)
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
func _on_button_pressed() -> void:
	get_tree().quit()
