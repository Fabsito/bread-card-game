extends Control

@onready var card_manager = $"../card_manager"
@onready var text: RichTextLabel = $back_ground/text

func _ready():
	card_manager.child_entered_tree.connect(_on_card_changed)
	card_manager.child_exiting_tree.connect(_on_card_changed)
	_update_cards_left()

func _on_card_changed(_node):
	_update_cards_left.call_deferred()

func _update_cards_left():
	var player_hand_size = card_manager.get_child_count()
	text.text = "cards left : [b][color=green]" + str(player_hand_size) + "[/color][/b]"
