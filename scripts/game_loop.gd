extends Node
@onready var player_hand: Node2D = $"../player_hand"
@onready var deck: Sprite2D = $"../deck"
@onready var enemy: Node2D = $"../enemy"
@onready var player: Node2D = $"../player"
@onready var ui: Control = $"../UI"  # ← agregar esta línea
@onready var game_loop = get_tree().get_first_node_in_group("game_loop")
const CARDS_PER_TURN: int = 3

enum Phase { PLAYER_TURN, ENEMY_TURN }
var current_phase: Phase = Phase.PLAYER_TURN

func _ready() -> void:
	await get_tree().process_frame  # ← espera un frame
	start_player_turn()

# =========================================================
# TURNO DEL JUGADOR
# =========================================================

func start_player_turn() -> void:
	current_phase = Phase.PLAYER_TURN
	player.on_turn_start()
	player.process_poison()
	_draw_cards_for_turn()
	ui.update_ui()  

func _draw_cards_for_turn() -> void:
	var cards = deck.draw_cards(CARDS_PER_TURN)
	for card in cards:
		player_hand.add_card_to_hand(card)

## Llamar este método desde tu botón de fin de turno
func end_player_turn() -> void:
	if current_phase != Phase.PLAYER_TURN:
		return
	player_hand.delete_cards()
	start_enemy_turn()

# =========================================================
# TURNO DEL ENEMIGO
# =========================================================

func start_enemy_turn() -> void:
	current_phase = Phase.ENEMY_TURN
	enemy.do_attack(player)
	ui.update_ui()          # ← actualiza UI tras el ataque
	await get_tree().create_timer(1.0).timeout
	end_enemy_turn()

func end_enemy_turn() -> void:
	start_player_turn()
