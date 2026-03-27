extends Control
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var text_edit: Label = $TextEdit

func initiate_health_bar(max_health):
	progress_bar.max_value = max_health
func update_health(current_health,max_health):
	progress_bar.value = current_health
	text_edit.text = str(current_health) + "/" + str(max_health)
