extends Node2D

var card_data: CardData = null
var starting_pos: Vector2
@onready var card_img = $Area2D/card_img

func setup(data: CardData) -> void:
	card_data = data
	_apply_card_color()

func _apply_card_color() -> void:
	match card_data.card_type:
		CardData.CardType.ATTACK:
			card_img.modulate = Color(0.971, 0.185, 0.0, 1.0)  # rojo
		CardData.CardType.DEFEND:
			card_img.modulate = Color(0.517, 0.443, 0.54, 1.0)  # azul
		CardData.CardType.HEAL:
			card_img.modulate = Color(0.4, 1.0, 0.4)  # verde
		CardData.CardType.SPECIAL:
			card_img.modulate = Color(0.88, 0.0, 0.66, 1.0)  # morado

func play() -> void:
	if card_data == null:
		return
	var player = get_tree().get_first_node_in_group("player")
	var enemy = get_tree().get_first_node_in_group("enemy")
	if not player.spend_energy(card_data.energy_cost):
		return
	match card_data.card_type:
		CardData.CardType.ATTACK:
			enemy.take_damage(card_data.value + player.strength)
		CardData.CardType.DEFEND:
			player.add_block(card_data.value)
		CardData.CardType.HEAL:
			player.heal(card_data.value)
		CardData.CardType.SPECIAL:
			_apply_special(player, enemy)
	var ui = get_tree().get_first_node_in_group("ui")
	if ui:
		ui.update_ui()

func _apply_special(player: Node, enemy: Node) -> void:
	match card_data.special_effect:
		CardData.SpecialEffect.POISON:
			enemy.apply_poison(card_data.special_value)
		CardData.SpecialEffect.STRENGTH_UP:
			player.add_strength(card_data.special_value)
		CardData.SpecialEffect.SHIELD_UP:
			player.add_block(card_data.special_value)
