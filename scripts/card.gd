extends Sprite2D

@export_range(1,13) var value : int = 1
@export_enum("Hearth","Spades","Diamond","Club","No suit") var suit : String = "No suit"
@export var card_texture : Texture 
static var card_being_held = null
var original_position : Vector2
var is_on_drop_zone : bool = false
var current_slot = null

var hold :bool = false
func _ready() -> void:
	texture = card_texture

func _process(_delta: float) -> void:
	if hold:
		global_position = get_global_mouse_position()

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
		
		var drop_zone = get_tree().get_first_node_in_group("drop_zone")
		
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
			else:
				back_to_deck()
		else:
			back_to_deck()

func back_to_deck():
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_position, 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func animate_to_pos(target_pos: Vector2):
	var tween = create_tween()
	tween.tween_property(self, "global_position", target_pos, 0.15).set_trans(Tween.TRANS_SINE)
