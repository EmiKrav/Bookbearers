extends TextureButton

@onready var insertName = preload("res://Bookbearers/Scenes/insertname.tscn")

func _on_pressed():
	get_tree().change_scene_to_packed(insertName)
