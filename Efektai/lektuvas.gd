extends MeshInstance3D
func zaib():
	await get_tree().create_timer(20).timeout
	$".".queue_free()
	
func _ready():
	zaib();
