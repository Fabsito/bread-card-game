# deck.gd
extends Sprite2D

const CARD_SCENE = preload("uid://b0bddfu4w10nu")
@onready var card_manager: Node2D = $"../card_manager"

const ATTACK = preload("res://cards/attack.tres")
const DEFEND = preload("res://cards/defend.tres")
const HEAL   = preload("res://cards/heal.tres")
const POISON = preload("res://cards/poison.tres")

var player_deck: Array = [
	ATTACK, ATTACK, ATTACK,
	DEFEND, DEFEND,
	HEAL,
	POISON,
]
var discard_pile: Array = []  # ← pila de descarte

func _ready() -> void:
	position = Vector2(50, get_viewport_rect().size.y - 50)
	player_deck.shuffle()

func draw_cards(amount: int) -> Array:
	if not card_manager:
		push_error("card_manager es null en deck.gd")
		return []

	var drawn = []
	for i in amount:
		# Si el mazo está vacío, rebarajar el descarte
		if player_deck.is_empty():
			if discard_pile.is_empty():
				break  # no quedan cartas en ningún lado
			_reshuffle_discard()

		var card_data: CardData = player_deck.pop_back()
		var new_card = CARD_SCENE.instantiate()
		card_manager.add_child(new_card)
		new_card.name = card_data.card_name
		new_card.setup(card_data)
		drawn.append(new_card)

	visible = player_deck.size() > 0
	return drawn

## Mueve el descarte al mazo y baraja
func _reshuffle_discard() -> void:
	player_deck = discard_pile.duplicate()
	discard_pile.clear()
	player_deck.shuffle()
	visible = true

## Llamar cuando una carta se juega o se descarta
func add_to_discard(card_data: CardData) -> void:
	discard_pile.append(card_data)

func is_empty() -> bool:
	return player_deck.is_empty() and discard_pile.is_empty()
