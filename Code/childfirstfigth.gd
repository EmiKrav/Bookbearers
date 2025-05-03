extends Node2D


@onready var firstfight = preload("res://Bookbearers/Scenes/firstfight.tscn")

func _on_video_stream_player_finished():
	get_tree().change_scene_to_packed(firstfight)
