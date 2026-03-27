extends Node2D
@onready var main: Node2D = $".."
const HAND_COUNT: int = 5

const Card = preload("uid://b0bddfu4w10nu")
const CARD_WIDTH : int= 40
var hand_y_position
@onready var card_manager: Node2D = $"../card_manager"
var player_hand :Array = []
var center_screen_x

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	center_screen_x =viewport_size.x /2
	hand_y_position = get_viewport_rect().size.y - 50

func animate_card_to_position(card , new_position:Vector2):
	var tween := get_tree().create_tween()
	tween.tween_property(card,"global_position",new_position,0.1)
func  add_card_to_hand(card):
	if card not in player_hand:
		player_hand.insert(0,card)
		update_hand_positions()
	else:
		animate_card_to_position(card,card.starting_pos)

func update_hand_positions():
	for i in range(player_hand.size()):
		var new_pos = calculate_card_position(i)
		var card = player_hand[i]
		card.starting_pos = new_pos
		animate_card_to_position(card , new_pos)

func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * float(CARD_WIDTH)
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return Vector2(x_offset, hand_y_position)

func remove_card_from_hand(card):
	if card in player_hand:
		player_hand.erase(card)
		update_hand_positions()

func delete_cards():
	for card in player_hand:
		if is_instance_valid(card):
			card.queue_free()
	player_hand.clear()
