extends Sprite2D
@onready var player_hand: Node2D = $"../player_hand"
const CARD = preload("uid://b0bddfu4w10nu")
@onready var card_manager: Node2D = $"../card_manager"
@onready var deck: Sprite2D = $"."
var player_deck = ["blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","blue","red","red"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck.position = Vector2(50,get_viewport_rect().size.y - 50)
	draw_cards()


func draw_cards():
 
	if player_deck.size() >= player_hand.HAND_COUNT:
		for i in player_hand.HAND_COUNT:
			var new_card = CARD.instantiate()
			card_manager.add_child(new_card)
			new_card.name = "card"
			player_hand.add_card_to_hand(new_card)
			player_deck.pop_back()
			
	else:
		for i in range(player_deck.size()):
			var new_card = CARD.instantiate()
			card_manager.add_child(new_card)
			new_card.name = "card"
			player_hand.add_card_to_hand(new_card)
			player_deck.pop_back()
			deck.visible = false
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("space_bar") && player_deck.size() > 0:
		player_hand.delete_cards()
		draw_cards()
