extends TextureButton

@onready var cinematic = preload("res://Bookbearers/Scenes/cinematicvideo.tscn")


func  _ready():
	$".".disabled = true
	

func _on_pressed():
	Global.AddName($"../LineEdit".text)
	get_tree().change_scene_to_packed(cinematic)


func _on_line_edit_text_changed(new_text):
	if new_text.length() > 0:
		$".".disabled = false
	else :
		$".".disabled = true
