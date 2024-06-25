extends TextureButton


func  _ready():
	$".".disabled = true
	

func _on_pressed():
	Global.AddName($"../LineEdit".text)
	print(Global.childName)


func _on_line_edit_text_changed(new_text):
	if new_text.length() > 0:
		$".".disabled = false
	else :
		$".".disabled = true
