extends Node2D

# --- Referencias ---
@onready var player_hand: Node2D = $"../player_hand"
@onready var main = $".."
@onready var deck = $"../deck"

# --- Estado de drag ---
var card_being_dragged: Node2D = null
var card_collider: Node2D = null

# --- Estado de hover ---
var is_hovering_over_card: bool = false

# =========================================================
# LOOP PRINCIPAL
# =========================================================

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if card_being_dragged:
		card_being_dragged.global_position = get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clickL"):
		var hit = _raycast_cards()
		if hit:
			card_collider = hit
			_start_drag(card_collider)

	elif event.is_action_released("clickL"):
		_end_drag(card_collider)
		card_collider = null  # limpiar siempre al soltar

# =========================================================
# DRAG
# =========================================================

func _start_drag(card: Node2D) -> void:
	card_being_dragged = card
	card.scale = Vector2.ONE

func _end_drag(card: Node2D) -> void:
	card_being_dragged = null
	if not card:
		return
	var slot_found = _raycast_slots()
	if slot_found:
		card.play()
		print("deck encontrado: ", deck)
		if deck and card.card_data:
			print("agregando al descarte: ", card.card_data.card_name)
			deck.add_to_discard(card.card_data)
		player_hand.remove_card_from_hand(card)
		card.queue_free()
	else:
		card.scale = Vector2(1.05, 1.05)
		player_hand.add_card_to_hand(card)
# =========================================================
# RAYCASTS
# =========================================================

func _raycast_cards() -> Node2D:
	var result = _query_point(1)
	if result.is_empty():
		return null
	var card = _get_topmost(result)
	if card == main:
		return null
	return card

func _raycast_slots() -> Node2D:
	var result = _query_point(2)
	if result.is_empty():
		return null
	var hit = _get_topmost(result)
	if hit == main:
		return hit
	return null

func _query_point(mask: int) -> Array:
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = mask
	return space_state.intersect_point(params)

func _get_topmost(hits: Array) -> Node2D:
	var top = hits[0].collider.get_parent()
	for hit in hits:
		var candidate = hit.collider.get_parent()
		if candidate.z_index > top.z_index:
			top = candidate
	return top

# =========================================================
# HOVER
# =========================================================

func connect_card_signals(card: Node2D) -> void:
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)

func on_hovered_over_card(card: Node2D) -> void:
	if not is_hovering_over_card:
		is_hovering_over_card = true
		_highlight_card(card, true)

func on_hovered_off_card(card: Node2D) -> void:
	_highlight_card(card, false)
	var next = _raycast_cards()
	if next:
		_highlight_card(next, true)
	else:
		is_hovering_over_card = false

func _highlight_card(card: Node2D, hovered: bool) -> void:
	card.scale = Vector2(1.05, 1.05) if hovered else Vector2.ONE
	card.z_index = 2 if hovered else 1
