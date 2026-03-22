extends Sprite2D

@export_range(1,13) var value : int = 1
@export_enum("Hearth","Spades","Diamond","Club","No suit") var suit : String = "No suit"
@export var card_texture : Texture 
static var card_being_held = null
var original_position : Vector2
var is_on_drop_zone : bool = false
var current_slot = null
var is_hovering : bool = false
var hold: bool = false # Define la variable para que sort_hand pueda leerla
signal request_reorder(card, global_pos)
var target_index = -1

func _ready() -> void:
	texture = card_texture

func _process(_delta: float) -> void:
	if hold:
		global_position = global_position.lerp(get_global_mouse_position(), 0.25)
		request_reorder.emit(self, global_position)
	if is_hovering: 
		_on_card_hover(self)

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed and get_rect().has_point(to_local(event.global_position)):
			hold = true
			z_index = 100 # Al frente mientras se arrastra
		else:
			hold = false
			z_index = 0

func _on_area_2d_card_action(left: bool) -> void:
	if left:
		if card_being_held == null:
			hold = true
			card_being_held = self
			original_position = global_position
			z_index = 100 
			print("Card picked : ", value, " " , suit)
			
	if not left:
		print("right click")

func _on_area_2d_card_release(left: bool) -> void:
	if left and hold:
		hold = false
		card_being_held = null
		z_index = 0
		set_on_drop_zone(Area2D)
	else:
		back_to_deck()


func back_to_deck():
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_position, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func animate_to_pos(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.15).set_trans(Tween.TRANS_SINE)

func setup_hover_events(card_node: Node2D):
	# Asumiendo que la carta tiene un Area2D o es un Control
	self.mouse_entered.connect(_on_card_hover.bind(card_node, true))
	self.mouse_exited.connect(_on_card_hover.bind(card_node, false))

func _on_card_hover(card: Node2D,) -> void:
	var tween = create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	
	if is_hovering:
		# Escala más grande y sube un poco (eje Y negativo es arriba)
		tween.tween_property(card, "scale", Vector2(1.6, 1.6), 0.2)
		# Usamos un offset relativo para que no pierda su posición en el abanico
		card.z_index = 100 # Se pone al frente de las demás
		print("¡Ratón detectado sobre la carta!")
	else:
		# Vuelve a su tamaño normal
		tween.tween_property(card, "scale", Vector2(0.6, 0.6), 0.2)
		card.z_index = 0

func set_on_drop_zone(area):
	var drop_zone = get_tree().get_first_node_in_group("drop_zone")
	is_on_drop_zone=true
	printerr("is on drop zone :", is_on_drop_zone)
	if is_on_drop_zone and drop_zone != null:
		var slot = drop_zone.get_closest_slot(global_position)
	
		if slot:
			if get_parent() != drop_zone:
				get_parent().remove_child(self)
				drop_zone.add_child(self)
			
			drop_zone.release_slot(self)
			slot.occupied = true
			slot.card = self
			current_slot = slot
			animate_to_pos(slot.pos) 
