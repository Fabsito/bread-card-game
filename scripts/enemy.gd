# enemy.gd
extends Node2D

var max_health: int = 50
var current_health: int = 50
var block: int = 0
var min_attack: int = 5
var max_attack: int = 12

func take_damage(amount: int) -> void:
	var damage = max(0, amount - block)
	block = max(0, block - amount)
	current_health = max(0, current_health - damage)
	print("Enemigo recibe %d daño — HP: %d" % [damage, current_health])
	if current_health <= 0:
		die()

func do_attack(player: Node) -> void:
	var damage = randi_range(min_attack, max_attack)
	print("Enemigo ataca por %d" % damage)
	player.take_damage(damage)

func die() -> void:
	get_tree().paused = true  # pausa el juego inmediatamente
	await get_tree().process_frame
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/victory.tscn")
