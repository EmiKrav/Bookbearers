extends Node2D

func _ready():
	Global.animationplaying = true
	Music.SoundStop()
	Music.playsoundmagicspell()

func _on_video_stream_player_finished():
	Global.animationplaying = false
	Music.SoundStop()
	queue_free()
