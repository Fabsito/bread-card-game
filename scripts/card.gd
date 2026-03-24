extends Node2D
signal hovered
signal hovered_off
@onready var card: Node2D = $"."
@onready var area_2d: Area2D = $Area2D
var starting_pos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(50,get_viewport_rect().size.y - 50)
	get_parent().connect_card_signals(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	card.global_position = area_2d.global_position




func _on_area_2d_mouse_entered() -> void:
	emit_signal("hovered",self)


func _on_area_2d_mouse_exited() -> void:
	emit_signal("hovered_off",self)
