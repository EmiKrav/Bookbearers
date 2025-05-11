extends TextureButton

@onready var insertName = preload("res://Bookbearers/Scenes/insertname.tscn")

func _on_pressed():
	get_tree().change_scene_to_packed(insertName)


func _on_button_4_pressed():
	get_tree().quit()


func _on_button_3_pressed():
	get_tree().change_scene_to_file("res://Bookbearers/Scenes/settings.tscn")

