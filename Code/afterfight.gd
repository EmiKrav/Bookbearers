extends Node2D

@onready var zemelapis = load("res://Bookbearers/Scenes/zemelapis.tscn")

func _on_video_stream_player_finished():
	if Global.grafspot == 5:
		Global.grafspot = 2
	elif Global.grafspot == 22:
		Global.grafspot = 19
	elif Global.grafspot == 24:
		Global.grafspot = 23
	elif Global.grafspot == 37:
		Global.grafspot = 36
	elif Global.grafspot == 47:
		Global.grafspot = 46
	elif Global.grafspot == 60:
		Global.grafspot = 59
	get_tree().change_scene_to_packed(zemelapis)
