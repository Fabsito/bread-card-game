extends Node2D

@onready var deck: Node2D = $Deck

func _on_button_pressed() -> void:
	deck.draw_card()


func _on_quit_pressed() -> void:
	get_tree().quit()
