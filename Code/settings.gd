extends Node2D

var chosensize = 1
var mvolume = Global.MusicVol
var sfxvolume = Global.SoundVol
func _ready():
	%MusicLabel.text = "MUSIC: " + str(mvolume)
	%SoundLabel.text = "SFX: " + str(sfxvolume)
func _on_texture_rect_5_pressed():
	if %ScreenLabel.text == "FULLSCREEN":
		%ScreenLabel.text = "WINDOWED"
	elif %ScreenLabel.text == "WINDOWED":
		%ScreenLabel.text = "FULLSCREEN"
	
	%ScreenLabel
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_texture_rect_2_pressed():
	Global.MusicVol = mvolume
	Global.SoundVol = sfxvolume
	get_tree().change_scene_to_file("res://Bookbearers/Scenes/mainmenu.tscn")


func _on_texture_rectsize_pressed():
	if chosensize == 1:
		get_window().size = Vector2(1920,1080)
	if chosensize == 2:
		get_window().size = Vector2(1280,720)
	if chosensize == 3:
		get_window().size = Vector2(3840,2160)


func _on_texture_rectsizechoose_pressed():
	if chosensize < 3:
		chosensize += 1
		if chosensize == 2:
			%ResolutionLabel.text = str("1280×720")
		if chosensize == 3:
			%ResolutionLabel.text = str("3840×2160")
	else:
		chosensize = 1
		%ResolutionLabel.text = str("1920×1080")



func _on_musicvu_pressed():
	if mvolume < 100:
		mvolume +=5;
		%MusicLabel.text = "MUSIC: " + str(mvolume)
		Music.MusicChangeVolume(+5)
		if Music.Mmuted:
			Music.Mmuted = false
			Music.MusicResume()

func _on_musicvd_pressed():
	if mvolume > 0:
		mvolume -=5;
		%MusicLabel.text = "MUSIC: " + str(mvolume)
		Music.MusicChangeVolume(-5)
		if mvolume == 0:
			Music.Mmuted = true
			Music.MusicStop()
			Music.MusicReset()

func _on_sfxvd_pressed():
	if sfxvolume > 0:
		sfxvolume -=5;
		%SoundLabel.text = "SFX: " + str(sfxvolume)
		Music.SoundChangeVolume(-5)
		if sfxvolume == 0:
			Music.Smuted = true
			Music.SoundReset()

func _on_sfxvu_pressed():
	if sfxvolume < 100:
		sfxvolume +=5;
		%SoundLabel.text = "SFX: " + str(sfxvolume)
		Music.SoundChangeVolume(+5)
		if Music.Smuted:
			Music.Smuted = false

func _on_musicvumute_pressed():
	Music.Mmuted = true
	Music.MusicStop()
	Music.MusicReset()
	mvolume = 0
	%MusicLabel.text = "MUSIC: " + str(mvolume)


func _on_soundmute_pressed():
	Music.Smuted = true
	sfxvolume = 0
	$Sound.SoundStop()
	$Sound.SoundReset()
	%SoundLabel.text = "SFX: " + str(sfxvolume)
