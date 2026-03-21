extends TextureRect
var ROTACTIVE = false
var YROT = 0.0
var XROT = 0.0
# Called when the node enters the scene tree for the first time.
func _ready(): pass

func _Update_X(value: float):
# This function will be called repeatedly during the tween with the interpolated ‘value’
	set_instance_shader_parameter("x_rot", value)

func _Update_Y(value: float):
# This function will be called repeatedly during the tween with the interpolated ‘value’
	set_instance_shader_parameter("y_rot", value)

func _process(delta: float) -> void:
	var center_x = global_position.x + (size.x / 2)
	var mouse_x = get_viewport().get_mouse_position().x
	var result_x = (center_x - mouse_x) / (size.x / 50)
	XROT = result_x
	var center_y = global_position.y + (size.y / 2)
	var mouse_y = get_viewport().get_mouse_position().y
	var result_y = (center_x - mouse_x) / (size.x / 50)
	YROT = result_y
	if ROTACTIVE:
		set_instance_shader_parameter("x_rot", YROT)
		set_instance_shader_parameter("y_rot", XROT)
	else: pass

func _Tween_X_To_Base():
	var tween = create_tween()
	tween.tween_method(Callable(self, "_Update_X"), get_instance_shader_parameter("x_rot"), 0.0, 0.1) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)

func _Tween_Y_To_Base():
	var tween = create_tween()
	tween.tween_method(Callable(self, "_Update_Y"), get_instance_shader_parameter("y_rot"), 0.0, 0.1) \
	.set_trans(Tween.TRANS_QUAD) \
	.set_ease(Tween.EASE_OUT)

func _on_area_2d_mouse_entered() -> void:
	ROTACTIVE = true

func _on_area_2d_mouse_exited() -> void:
	ROTACTIVE = false
	_Tween_X_To_Base()
	_Tween_Y_To_Base()
