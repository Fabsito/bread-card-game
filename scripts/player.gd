extends Node2D
var energy:int = 3
var max_health:int = 75
var current_health:int = 75
@onready var container: Control = $Container

func _ready() -> void:
	container.initiate_health_bar(max_health)
	container.update_health(current_health,max_health)
