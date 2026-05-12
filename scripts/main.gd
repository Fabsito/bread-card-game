extends Node2D

const ENEMY_STAGE = preload("uid://b5f84ybioa1tn")


func _on_change_enemy_scene_pressed() -> void:
	get_tree().change_scene_to_packed(ENEMY_STAGE)

func _on_quit_pressed() -> void:
	get_tree().quit()
