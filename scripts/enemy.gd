# enemy.gd
extends Node2D
@onready var sprite: Sprite2D = $Sprite2D

const DAMAGE_NUMBER = preload("res://Scenes/damage_number.tscn")

var max_health: int = 100
var current_health: int = 100
var block: int = 0
var min_attack: int = 5
var max_attack: int = 15

func _ready() -> void:
	sprite.position = Vector2(320, 100) 

func do_attack(player: Node) -> void:
	var damage = randi_range(min_attack, max_attack)
	player.take_damage(damage)

func die() -> void:
	get_tree().paused = true  # pausa el juego inmediatamente
	await get_tree().process_frame
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/victory.tscn")

func take_damage(amount: int) -> void:
	var damage = max(0, amount - block)
	block = max(0, block - amount)
	current_health = max(0, current_health - damage)
	_show_damage_number(damage)
	if current_health <= 0:
		die()

func _show_damage_number(value: int) -> void:
	var num = DAMAGE_NUMBER.instantiate()
	get_parent().add_child(num)
	num.global_position =  Vector2(320, 100)   # ajusta según tu pantalla
	num.setup(value, Color(0.576, 0.0, 0.085, 1.0))

func on_turn_start() -> void:
	block = 0
