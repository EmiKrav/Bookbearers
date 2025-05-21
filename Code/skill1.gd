extends Node2D


func _ready():
	Music.SoundStop()
	Music.playsoundattacking()

func _on_video_stream_player_finished():
	Global.animationplaying = false
	Music.SoundStop()
	queue_free()
