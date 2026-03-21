extends Node2D

@export var spacing : float = 60.0
@export var hover_spacing : float = 30.0 
@export var vertical_arc : float = 15.0

var hovered_card = null

func _process(_delta):
	sort_hand()

func sort_hand():
	var cards = get_children()
	var total_cards = cards.size()
	if total_cards == 0: return

	# 1. Lógica de Reordenamiento (Drag & Drop)
	var dragging_card = null
	for c in cards:
		if c.hold: dragging_card = c
	
	if dragging_card:
		_handle_reordering(dragging_card, cards)

	# 2. Lógica de Posicionamiento y Espaciado de Hover
	var start_x = -(total_cards - 1) * spacing / 2.0
	
	for i in range(total_cards):
		var card = cards[i]
		if card.hold: continue
		
		var target_x = start_x + (i * spacing)
		
		# --- EFECTO DE APARTARSE ---
		if hovered_card != null:
			var hovered_idx = hovered_card.get_index()
			if i < hovered_idx:
				target_x -= hover_spacing # Se mueven a la izquierda
			elif i > hovered_idx:
				target_x += hover_spacing # Se mueven a la derecha

		# Posicionamiento final
		var offset_from_center = abs(i - (total_cards - 1) / 2.0)
		var target_y = offset_from_center * offset_from_center * (vertical_arc / 2.0)
		
		# Si es la carta bajo el ratón, la subimos un poco más
		if card == hovered_card:
			target_y -= 40 
			card.z_index = 50
		else:
			card.z_index = i

		card.position = card.position.lerp(Vector2(target_x, target_y), 0.15)
		card.rotation = lerp_angle(card.rotation, (i - (total_cards - 1) / 2.0) * 0.1, 0.15)

func _handle_reordering(dragging_card, cards):
	var mouse_x = dragging_card.position.x
	for i in range(cards.size()):
		var other_card = cards[i]
		if other_card == dragging_card: continue
		
		# Si arrastramos la carta más allá de la mitad de su vecina, cambiamos índice
		if mouse_x > other_card.position.x and dragging_card.get_index() < i:
			move_child(dragging_card, i)
		elif mouse_x < other_card.position.x and dragging_card.get_index() > i:
			move_child(dragging_card, i)

func _on_card_mouse_entered(card):
	hovered_card = card

func _on_card_mouse_exited(_card):
	hovered_card = null
