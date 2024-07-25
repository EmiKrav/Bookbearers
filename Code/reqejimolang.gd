extends Sprite3D

@onready var player = get_parent().get_parent()

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
			player.judeti($Label2.text)
