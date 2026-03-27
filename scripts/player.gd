extends Node2D
var energy:int = 3
var max_health:int = 100
var current_health:int = 100
@onready var container: Control = $Container
@onready var text: RichTextLabel = $"../text"
