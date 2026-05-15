extends Control

@onready var text_edit: Label = $TextEdit 
@onready var progress_bar: ProgressBar = $ProgressBar

# Definimos sb como un StyleBoxFlat para poder modificarlo
var sb: StyleBoxFlat

func _ready():
	# IMPORTANTE: Creamos un estilo nuevo y ÚNICO para esta barra
	sb = StyleBoxFlat.new()
	# Le damos un color inicial para probar
	sb.bg_color = Color.GREEN
	# Lo aplicamos a la propiedad 'fill' de la ProgressBar
	progress_bar.add_theme_stylebox_override("fill", sb)

func initiate_health_bar(max_health):
	progress_bar.max_value = max_health
	progress_bar.value = max_health

func update_health(current_health, max_health):
	# 1. Actualizar el valor visual de la barra
	progress_bar.value = current_health
	
	# 2. Actualizar el texto
	if text_edit:
		text_edit.text = "HP: " + str(current_health) + "/" + str(max_health)
	
	# 3. Calcular porcentaje (asegurando que sea float)
	var percentage = float(current_health) / float(max_health)
	
	# DEBUG: Descomenta la línea de abajo para ver el porcentaje en la consola
	# print("Vida actual: ", current_health, " Porcentaje: ", percentage)

	# 4. Cambiar el color del StyleBox que YA ESTÁ aplicado
	if percentage > 0.6:
		sb.bg_color = Color.GREEN
	elif percentage > 0.25:
		sb.bg_color = Color.YELLOW
	else:
		sb.bg_color = Color.RED
