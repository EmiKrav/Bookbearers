extends CanvasLayer


@onready var mainmenu = preload("res://Bookbearers/Scenes/mainmenu.tscn")

func _ready():
	Global.load_from_file()
	Music.play1()
func _on_video_stream_player_finished():
	get_tree().change_scene_to_packed(mainmenu)

func _process(delta):
	if Input.is_action_just_pressed("Skip"):
		get_tree().change_scene_to_packed(mainmenu)
