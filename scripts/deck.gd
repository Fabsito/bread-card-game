extends Node2D

@export var cards : Array[Resource]
@export var cardScene : PackedScene
@export var hand : Node2D

@export var spread_curve : float = 40.0 # Cuánto se separan las cartas
@export var rotation_curve : float = 25.0 # Inclinación de las cartas (abanico)

func draw_card() -> void:
	if cards.is_empty():
		print("No cards left!")
		return
	var data = cards.pop_back()
	var card = cardScene.instantiate()
	
	card.value = data.value
	card.suit = data.suit
	card.card_texture = data.card_texture
	card.global_position = get_global_mouse_position() 
	hand.add_child(card)
	
	reorganize_hand()

func reorganize_hand() -> void:
	var children = hand.get_children()
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
