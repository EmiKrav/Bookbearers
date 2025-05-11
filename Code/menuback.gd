extends Node2D


func _on_texture_rect_2_pressed():
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://Bookbearers/Scenes/mainmenu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == true:
			get_tree().paused = false;
			queue_free()
