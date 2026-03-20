extends Node2D

@export var spacing : float = 45.0

func _process(_delta):
	sort_hand()

func sort_hand():
	var cards = get_children()
	var total_cards = cards.size()
	if total_cards == 0: return
	
	var start_x = -(total_cards - 1) * spacing / 2.0
	
	for i in range(total_cards):
		var card = cards[i]
		if not card.hold:
			var target_x = start_x + (i * spacing)
			var target_pos = Vector2(target_x, 0) 
			
			card.position = card.position.lerp(target_pos, 0.1)
