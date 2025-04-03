extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.scrolls.has($"."["text"]):
		get_parent().queue_free()
