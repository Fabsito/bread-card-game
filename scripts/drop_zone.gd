extends Area2D

var on_deck : bool = false
var slots = []

func _ready() -> void:
	for child in get_children():
		if child is Marker2D:
			slots.append({"pos": child.global_position, "occupied": false, "card": null})

func _on_area_entered(area: Area2D) -> void:
	var card = area.get_parent()
	if card.has_method("set_on_drop_zone"):
		card.set_on_drop_zone(true)

func _on_area_exited(area: Area2D) -> void:
	var card = area.get_parent()
	if card.has_method("set_on_drop_zone"):
		card.set_on_drop_zone(false)

func get_closest_slot(card_pos: Vector2):
	var closest = null
	var min_dist = 99999
	
	for slot in slots:
		if not slot.occupied:
			var dist = card_pos.distance_to(slot.pos)
			if dist < min_dist:
				min_dist = dist
				closest = slot
	return closest

func release_slot(card):
	for slot in slots:
		if slot.card == card:
			slot.occupied = false
			slot.card = null
