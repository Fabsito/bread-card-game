extends Node2D

@export var cards : Array[Resource]
@export var cardScene : PackedScene
@export var hand : Node2D

func draw_card() -> void:
	var data = cards.pop_back()
	var card = cardScene.instantiate()
	
	card.value = data.value
	card.suit = data.suit
	card.card_texture = data.card_texture
	
	card.global_position = hand.global_position
	hand.add_child(card)
	print(card.name)
