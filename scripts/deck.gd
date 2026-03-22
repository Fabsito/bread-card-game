extends Node2D

@export var cards : Array[Resource]
@export var cardScene : PackedScene
@onready var player_hand: Node2D = $"../Player_Hand"

@onready var enemy_hand: Node2D = $"../Enemy_Hand"

@export var spread_curve : float = 20.0 # Cuánto se separan las cartas
@export var rotation_curve : float = 15.0 # Inclinación de las cartas (abanico)

func draw_card() -> void:
	if cards.is_empty():
		print("No cards left!")
		return
	if player_hand:
		var data = cards.pop_back()
		var card = cardScene.instantiate()
	
		card.value = data.value
		card.suit = data.suit
		card.card_texture = data.card_texture
		card.global_position = get_global_mouse_position() 
		player_hand.add_child(card)
		print("draw card : card = ",card.name)
	elif enemy_hand:
		var data = cards.pop_back()
		var card = cardScene.instantiate()
	
		card.value = data.value
		card.suit = data.suit
		card.card_texture = data.card_texture
		card.global_position = get_global_mouse_position() 
		enemy_hand.add_child(card)
	
	reorganize_hand()

func reorganize_hand() -> void:
	var children = player_hand.get_children()
	var count = children.size()
	
	for i in range(count):
		var card = children[i]
		var target_x = (i - (count - 1) / 2.0) * spread_curve
		var target_y = abs(target_x) * 0.2 
		var target_rotation = deg_to_rad((i - (count - 1) / 2.0) * rotation_curve)
		var tween = create_tween().set_parallel(true)
		tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
		tween.tween_property(card, "position", Vector2(target_x, target_y), 0.5)
		tween.tween_property(card, "rotation", target_rotation, 0.5)

func _on_button_pressed() -> void:
	draw_card()
