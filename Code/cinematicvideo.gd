extends VideoStreamPlayer


@onready var turtorial = preload("res://Bookbearers/Scenes/turtorial.tscn")


func _process(delta):
	if Input.is_action_just_pressed("Skip"):
		get_tree().change_scene_to_packed(turtorial)
