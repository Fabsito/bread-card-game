extends Node2D
var card_being_dragged : Node2D
var mouse_postion
@onready var player_hand: Node2D = $"../player_hand"
var card_collider: Node2D 
@onready var main: Node2D = $".."
var is_hovering_over_card: bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if card_being_dragged:
		mouse_postion = get_global_mouse_position()
		card_being_dragged.global_position = mouse_postion
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("clickL") :
		card_collider = raycast()
		if card_collider:
			start_drag(card_collider)
	elif event.is_action_released("clickL"):
		end_drag(card_collider)
# Called when the node enters the scene tree for the first time.
func raycast():
	var space_state = get_world_2d().direct_space_state
	var parameters =  PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 1
	var result = space_state.intersect_point(parameters)
	if !result.is_empty():
		if get_card_on_top(result) != main:
			return get_card_on_top(result)
		else:
			return
	else:
		return
func connect_card_signals(card):
	card.connect("hovered", on_hovered_over_card)
	card.connect("hovered_off", on_hovered_off_card)
func on_hovered_over_card(card):
	if !is_hovering_over_card:
		is_hovering_over_card = true
		highlight_card(card,true)
func on_hovered_off_card(card):
		highlight_card(card,false)
		var new_card_hoverd = raycast()
		if new_card_hoverd:
			highlight_card(new_card_hoverd,true)
		else:
			is_hovering_over_card = false
func highlight_card(card,hovered ):
	if hovered :
		card.scale = Vector2(1.05, 1.05)
		card.z_index = 2
	else:
		card.scale = Vector2(1, 1.0)
		card.z_index =1
func _ready() -> void:
	pass # Replace with function body.
func get_card_on_top(cards):
	var card_on_top = cards[0].collider.get_parent()
	for i in cards:
		var current_card = i.collider.get_parent()
		if current_card.z_index > card_on_top.z_index :
			card_on_top = current_card
	return card_on_top
func start_drag(card):
	card_being_dragged = card
	card.scale = Vector2(1,1)
func end_drag(card):
	card_being_dragged = null
	var card_slot_found = raycast_for_slot()
	if card:
		card.scale = Vector2(1.05,1.05)
		if card && card_slot_found:
			card.queue_free()
			player_hand.remove_card_from_hand(card)
		else:
			player_hand.add_card_to_hand(card)
func raycast_for_slot():
	var space_state = get_world_2d().direct_space_state
	var parameters =  PhysicsPointQueryParameters2D.new()
	parameters.position = get_global_mouse_position()
	parameters.collide_with_areas = true
	parameters.collision_mask = 2
	var result = space_state.intersect_point(parameters)
	if !result.is_empty():
		if get_card_on_top(result) == main:
			return get_card_on_top(result)
		else:
			return
	else:
		return
