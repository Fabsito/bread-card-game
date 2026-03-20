extends Area2D

signal card_action(left : bool)

signal card_release(left:bool)

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("clickL"):
		card_action.emit(true)
	if event.is_action_pressed("clickR"):
		card_action.emit(false)
	if event.is_action_released("clickL"):
		card_release.emit(true)
	if event.is_action_released("clickR"):
		card_release.emit(false)
		
