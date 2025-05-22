extends Node2D


func _on_texture_rect_2_pressed():
	Music.MusicStop()
	Music.SoundStop()
	if Global.grafspot == 5:
		Global.grafspot = 2
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 22:
		Global.grafspot = 19
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 24:
		Global.grafspot = 23
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 37:
		Global.grafspot = 36
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 47:
		Global.grafspot = 46
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 60:
		Global.grafspot = 59
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 4:
		Global.grafspot = 3
	elif Global.grafspot == 21:
		Global.grafspot = 19
	elif Global.grafspot == 31:
		Global.grafspot = 30
	elif Global.grafspot == 55:
		Global.grafspot = 54
	get_tree().paused = false;
	get_tree().change_scene_to_file("res://Bookbearers/Scenes/mainmenu.tscn")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused == true:
			get_tree().paused = false;
			Music.MusicStop()
			Music.SoundStop()
			queue_free()
