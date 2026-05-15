extends Node2D

const DAMAGE_NUMBER = preload("res://Scenes/damage_number.tscn")

var max_health: int = 50
var current_health: int = 100
var max_energy: int = 3
var energy: int = 3
var block: int = 0
var strength: int = 0
var poison_stacks: int = 0

func on_turn_start() -> void:
	block = 0
	energy = max_energy

func take_damage(amount: int) -> void:
	var damage = max(0, amount - block)
	block = max(0, block - amount)
	current_health = max(0, current_health - damage)
	current_health = max(0, current_health)
	_show_damage_number(damage)
	if current_health == 0:
		die()
func add_block(amount: int) -> void:
	block += amount

func heal(amount: int) -> void:
	current_health = min(max_health, current_health + amount)

func add_strength(amount: int) -> void:
	strength += amount

func spend_energy(amount: int) -> bool:
	if energy >= amount:
		energy -= amount
		return true
	return false

func apply_poison(stacks: int) -> void:
	poison_stacks += stacks

func process_poison() -> void:
	if poison_stacks > 0:
		take_damage(poison_stacks)
		poison_stacks -= 1

func die() -> void:
	get_tree().paused = true
	await get_tree().process_frame
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/lose_screen.tscn")

func _show_damage_number(value: int) -> void:
	var num = DAMAGE_NUMBER.instantiate()
	get_parent().add_child(num)
	num.global_position = Vector2(200, 100)  # ajusta según tu pantalla
	num.setup(value, Color(0.53, 0.505, 0.472, 1.0))
