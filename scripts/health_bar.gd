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
	progress_bar.value = current_health
	if text_edit:
		text_edit.text = "HP: " + str(current_health) + "/" + str(max_health)
		var percentage = float(current_health) / float(max_health)
		if percentage > 0.6:
			sb.bg_color = Color(0.185, 0.747, 0.0, 1.0)  # verde
		elif percentage > 0.25:
			sb.bg_color = Color(0.691, 0.75, 0.25, 1.0)  # amarillo
		else:
			sb.bg_color = Color(0.915, 0.0, 0.16, 1.0)   # rojo
