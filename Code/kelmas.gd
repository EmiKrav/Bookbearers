extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(area.get_parent(), "position:y", area.get_parent().position.y+2.0, 0.5)
	await tween.finished

func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	var tween = create_tween().set_parallel(true)
	tween.tween_property(area.get_parent(), "position:y", 2.0, 0.5)
	await tween.finished

