extends CanvasLayer

@onready var hand = get_node("../Hand") # Ajusta la ruta a tu nodo Hand

func _ready():
	# Configuramos los sliders al arrancar con los valores actuales de la mano
	await get_tree().process_frame
	if hand == null:
		printerr("ERROR: No se encontró el nodo Hand. Revisa la ruta en get_node().")
		return
	
	setup_slider("Spacing", hand.spacing, 0, 200, func(v): hand.spacing = v)
	setup_slider("Hover Spacing", hand.hover_spacing, 0, 100, func(v): hand.hover_spacing = v)
	setup_slider("Vertical Arc", hand.vertical_arc, 0, 100, func(v): hand.vertical_arc = v)

func setup_slider(label_text: String, initial_value: float, min_v: float, max_v: float, callback: Callable):
	var container = VBoxContainer.new()
	var label = Label.new()
	var slider = HSlider.new()
	
	# Configuración inicial del Slider
	slider.min_value = min_v
	slider.max_value = max_v
	slider.step = 0.5 # Para que el movimiento sea suave pero con decimales
	slider.value = initial_value
	slider.custom_minimum_size.x = 200
	
	# Configuración inicial del Label
	label.text = "%s: %.1f" % [label_text, initial_value]
	
	# --- EL TRUCO ESTÁ AQUÍ ---
	# Conectamos la señal 'value_changed' del slider
	slider.value_changed.connect(func(new_value):
		# 1. Ejecutamos la función que cambia la variable en la Mano
		callback.call(new_value)
		
		# 2. Actualizamos el texto del Label en tiempo real
		# %.1f significa "un decimal flotante"
		label.text = "%s: %.1f" % [label_text, new_value]
	)
	
	# Añadimos todo al árbol de nodos
	container.add_child(label)
	container.add_child(slider)
	$PanelContainer/VBoxContainer.add_child(container)
