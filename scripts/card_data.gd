extends Resource
class_name CardData

enum CardType { ATTACK, DEFEND, HEAL, SPECIAL }
enum SpecialEffect { NONE, POISON, STRENGTH_UP, SHIELD_UP }

@export var card_name: String = ""
@export var description: String = ""
@export var energy_cost: int = 1
@export var card_type: CardType = CardType.ATTACK
@export var value: int = 0              # daño, bloqueo, o curación
@export var special_effect: SpecialEffect = SpecialEffect.NONE
@export var special_value: int = 0     # cuántos turnos de veneno, cuánta fuerza, etc
