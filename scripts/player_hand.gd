extends Node2D
const HAND_COUNT: int = 5
const Card = preload("uid://b0bddfu4w10nu")
const CARD_WIDTH : int= 100
var hand_y_position
@onready var card_manager: Node2D = $"../card_manager"
var player_hand :Array = []
var center_screen_x
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var viewport_size = get_viewport().size
	center_screen_x = card_manager.to_local(Vector2(viewport_size.x / 2, 0)).x
	hand_y_position = get_viewport().size.y - 300
	print(hand_y_position)
	for i in HAND_COUNT:
		var new_card = Card.instantiate()
		card_manager.add_child(new_card)
		new_card.name = "card"
		add_card_to_hand(new_card)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func animate_card_to_position(card , new_position):
	var tween := get_tree().create_tween()
	tween.tween_property(card,"position",new_position,0.1)
func  add_card_to_hand(card):
	player_hand.insert(0,card)
	update_hand_positions()
func update_hand_positions():
	for i in range(player_hand.size()):
		var new_pos = calculate_card_position(i)
		var card = player_hand[i]
		animate_card_to_position(card , new_pos)
		
func calculate_card_position(index):
	var total_width = (player_hand.size() - 1) * float(CARD_WIDTH)
	var x_offset = center_screen_x - total_width / 2.0 + index * float(CARD_WIDTH)
	return Vector2(x_offset, hand_y_position)
