extends Control

# --- Constants for easy balancing ---
const LOW_CARD_THRESHOLD = 2
const HIGH_CARD_THRESHOLD = 3
const COLOR_DANGER = "ff4545" # Red
const COLOR_FULL = "45ff45"   # Green
const COLOR_NORMAL = "ffffff" # White
# --- Node References ---
@onready var card_manager = $"../card_manager"
@onready var text: RichTextLabel = $back_ground/text

func _ready() -> void:
	text.pivot_offset = text.size / 2
	text.bbcode_enabled = true
	if card_manager:
		card_manager.child_entered_tree.connect(_on_hand_changed)
		card_manager.child_exiting_tree.connect(_on_hand_changed)
	_update_counter_display()

func _on_hand_changed(_node: Node) -> void:
	_update_counter_display.call_deferred()

func _update_counter_display() -> void:
	var hand_size = card_manager.get_child_count()
	var display_color = _get_color_for_size(hand_size)
	text.text = "Cards left: [color=#%s]%d[/color]" % [display_color, hand_size]
	_play_pop_animation()

func _get_color_for_size(size: int) -> String:
	if size <= LOW_CARD_THRESHOLD:
		return COLOR_DANGER
	elif size >= HIGH_CARD_THRESHOLD:
		return COLOR_FULL
	return COLOR_NORMAL

# --- Visual Effects ---
func _play_pop_animation() -> void:
	var tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	text.scale = Vector2(0.7, 0.7)
	tween.tween_property(text, "scale", Vector2(1.0, 1.0), 0.2)
# --- buttons ---
func _on_button_pressed() -> void:
	if card_manager.get_child_count() > 0:
		var last_card = card_manager.get_child(-1) 
		last_card.queue_free()
