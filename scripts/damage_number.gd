extends Node2D

@onready var label: Label = $Label

func setup(value: int, color: Color) -> void:
	label.text = str( "Damage : ",value)
	label.modulate = color
	_animate()

func _animate() -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", position + Vector2(0, -50), 0.8)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 0.8)
	tween.tween_callback(queue_free)
