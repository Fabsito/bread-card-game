extends Node2D
@onready var main: Node2D = $".."
const HAND_COUNT: int = 5

const Card = preload("uid://b0bddfu4w10nu")
const CARD_WIDTH : int= 40
var hand_y_position
@onready var card_manager: Node2D = $"../card_manager"
var player_hand :Array = []
var center_screen_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	center_screen_x =viewport_size.x /2
	print(center_screen_x)
	hand_y_position = get_viewport().size.y - 300
	for i in HAND_COUNT:
		var new_card = Card.instantiate()
		card_manager.add_child(new_card)
		new_card.name = "card"
		add_card_to_hand(new_card)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card , new_position):
	var tween := get_tree().create_tween()
	tween.tween_property(card,"global_position",new_position,0.1)
func  add_card_to_hand(card):
	player_hand.insert(0,card)
	update_hand_positions()
	print(player_hand)
func update_hand_positions():
	for i in range(player_hand.size()):
		var new_pos = calculate_card_position(i)
		var card = player_hand[i]
		animate_card_to_position(card , new_pos)
		
func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * float(CARD_WIDTH)
	var x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return Vector2(x_offset, hand_y_position)
