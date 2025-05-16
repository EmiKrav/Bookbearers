extends Node2D

var chosensize = 1
var mvolume = 50
var sfxvolume = 50
func _ready():
	$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/Label2/Label.text += str(mvolume)
	$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer3/HBoxContainer/Label2/Label.text += str(sfxvolume)
func _on_texture_rect_5_pressed():
	var mode := DisplayServer.window_get_mode()
	var is_window: bool = mode != DisplayServer.WINDOW_MODE_FULLSCREEN
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if is_window else DisplayServer.WINDOW_MODE_WINDOWED)


func _on_texture_rect_2_pressed():
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
			$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer5/TextureRectsize/Label.text = str("1280×720")
		if chosensize == 3:
			$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer5/TextureRectsize/Label.text = str("3840×2160")
	else:
		chosensize = 1
		$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer5/TextureRectsize/Label.text = str("1920×1080")



func _on_musicvu_pressed():
	if mvolume < 100:
		mvolume +=5;
		$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/Label2/Label.text = "MUSIC: " + str(mvolume)


func _on_musicvd_pressed():
	if mvolume > 0:
		mvolume -=5;
		$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/Label2/Label.text = "MUSIC: " + str(mvolume)



func _on_sfxvd_pressed():
	if sfxvolume > 0:
		sfxvolume -=5;
		$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer3/HBoxContainer/Label2/Label.text = "SFX: " + str(sfxvolume)


func _on_sfxvu_pressed():
	if sfxvolume < 100:
		sfxvolume +=5;
		$CanvasLayer/Panel/HBoxContainer/VBoxContainer/HBoxContainer3/HBoxContainer/Label2/Label.text = "SFX: " + str(sfxvolume)
