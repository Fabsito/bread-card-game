extends Node2D
@onready var back_ground: ColorRect = $back_ground
@onready var deck: Node2D = $GUI/Deck
@onready var menu_buttons: VBoxContainer = $"menu buttons"
var menu_buttons_visible : bool = false
var menu_active : bool = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("esc_key"):
		menu_active = !menu_active
		menu_buttons.visible = menu_active
		if menu_active:
			back_ground.material.set_shader_parameter("colour_1", Color(0x141e3cff))
			back_ground.material.set_shader_parameter("colour_2", Color(0.988, 0.639, 0.067, 1.0))
			back_ground.material.set_shader_parameter("colour_3", Color(0.0, 0.0, 0.0, 1.0))
		else:
			# Optional: Reset color when menu closes
			back_ground.material.set_shader_parameter("colour_1", Color.from_ok_hsl(0.195, 0.987, 0.751, 1.0))
			back_ground.material.set_shader_parameter("colour_2", Color.from_ok_hsl(0.949, 0.0, 0.909, 1.0))
			back_ground.material.set_shader_parameter("colour_3", Color.from_ok_hsl(0.0, 0.0, 0.0, 1.0))

func _on_button_pressed() -> void:
	deck.draw_card()

func _on_save_pressed() -> void:
	pass #TODO save 

func _on_load_pressed() -> void:
	pass #TODO load 

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_options_pressed() -> void:
	pass#TODO  options menu


func _on_resume_pressed() -> void:
	menu_buttons.visible = false
