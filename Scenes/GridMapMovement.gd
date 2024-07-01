extends GridMap

func _ready():
	$MeshInstance3D.position = Vector3(1,1.5,15)

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			if shoot_ray() != null:
				var pos = map_to_local(shoot_ray())
				var tween = create_tween()
				tween.tween_property($MeshInstance3D, "position", Vector3(pos.x, 1.5, pos.z), 1)
		
func shoot_ray():
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_position(mouse_pos, 0.0)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var ray_query = PhysicsRayQueryParameters3D.create(from,to)
	var raycast_result = get_world_3d().direct_space_state.intersect_ray(ray_query)
	var selection = map_selection(raycast_result)
	return selection

func map_selection(selection: Dictionary):
	if selection.is_empty():
		return
	if selection["collider"] is GridMap:
		var gridmap: GridMap = selection["collider"]
	##1##
		var locsel = to_local(selection.position)
		var pos = gridmap.local_to_map(locsel)
		#var selection_normal: Vector3 = selection.normal
		#if selection_normal == Vector3.RIGHT or selection_normal == Vector3.BACK:
			#pos += -Vector3i(selection_normal) + Vector3i.UP
		#elif selection_normal == Vector3.FORWARD or selection_normal == Vector3.LEFT:
			#pos += Vector3i.UP
		return pos
