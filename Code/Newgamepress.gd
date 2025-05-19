extends TextureButton

@onready var zemelapis = preload("res://Bookbearers/Scenes/zemelapis.tscn")
@onready var insertName = preload("res://Bookbearers/Scenes/insertname.tscn")
@onready var childturtorial = preload("res://Bookbearers/Scenes/firstfight.tscn")
@onready var turtorial = preload("res://Bookbearers/Scenes/turtorial.tscn")
@onready var cinematic = preload("res://Bookbearers/Scenes/cinematicvideo.tscn")


func _on_pressed():
	get_tree().change_scene_to_packed(insertName)


func _on_button_4_pressed():
	get_tree().quit()


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://Bookbearers/Scenes/settings.tscn")



func _on_button_2_pressed():
	if Global.childName != "?Name?":
		if Global.turtorialcomplete and Global.firstchildturtorialcomplete:
			Global.day += 1
			get_tree().change_scene_to_file("res://Bookbearers/Scenes/zemelapis.tscn")
		elif Global.turtorialcomplete and !Global.firstchildturtorialcomplete:
			get_tree().change_scene_to_packed(childturtorial)
		else:
			get_tree().change_scene_to_packed(cinematic)
