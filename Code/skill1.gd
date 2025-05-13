extends Node2D


func _on_video_stream_player_finished():
	queue_free()
