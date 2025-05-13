extends CanvasLayer


@onready var mainmenu = preload("res://Bookbearers/Scenes/mainmenu.tscn")

func _on_video_stream_player_finished():
	get_tree().change_scene_to_packed(mainmenu)
