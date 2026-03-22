extends CharacterBody2D

@onready var player: CharacterBody2D = $"../Player"

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var hp : float = 100.0
var alive : bool = true
var speed: int = 150

func _physics_process(delta: float) -> void:
	var direction = (player.position - position).normalized()
	var velocity = direction * speed
	look_at(player.position)
	move_and_slide()

func die():
	if hp <1 :
		get_tree().quit()

func _on_mouse_entered() -> void:
	hp = 0
	die()
