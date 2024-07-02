extends GridMap

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")

@export var movementPoints = 4

var selected = false
var currentpos
var moving = false
var redraw = false
var click = false
var cells
var movemcellls: Array = []

func _ready():
	$MeshInstance3D.position = Vector3(1,1.5,15)
	var pos = local_to_map(Vector3(1,1.5,15))
	currentpos = pos
	cells = get_used_cells()
	
func _process(delta):

	if redraw:
		if selected:
			redraw = false
			var pos = map_to_local(currentpos)
			var possprite = pos + Vector3(0,0.01,0)
			$Sprite3D.position = possprite
			#draw around
			for i in range(1, movementPoints+1):
				var mappos = currentpos + Vector3i(0,0,i)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					$".".add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for i in range(1, movementPoints+1):
				var mappos = currentpos + Vector3i(0,0,-i)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					$".".add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for i in range(1, movementPoints+1):
				var mappos = currentpos + Vector3i(i,0,0)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					$".".add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for i in range(1, movementPoints+1):
				var mappos = currentpos + Vector3i(-i,0,0)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					$".".add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for y in range(1, movementPoints+1):
				for i in range(1, movementPoints+1):
					var mappos = currentpos + Vector3i(y,0,i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						$".".add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			for y in range(1, movementPoints+1):
				for i in range(1, movementPoints+1):
					var mappos = currentpos + Vector3i(-y,0,-i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						$".".add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			for y in range(1, movementPoints+1):
				for i in range(1, movementPoints+1):
					var mappos = currentpos + Vector3i(-y,0,i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						$".".add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			for y in range(1, movementPoints+1):
				for i in range(1, movementPoints+1):
					var mappos = currentpos + Vector3i(y,0,-i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						$".".add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
		
		if !selected:
			redraw = false
			$Sprite3D.position = Vector3(0,0,0)
			for i in range(3, get_child_count()+1):
				if $".".get_child(i-1) != null:
					$".".get_child(i-1).queue_free()
		
	if !click && !moving && selected:
		if Input.is_action_pressed("Click"):
			
			if shoot_ray() != null:
				var langelis = shoot_ray()
				if movemcellls.has(langelis):
					var pos = map_to_local(langelis)
					moving = true
					selected = false
					redraw = true
					var tween = create_tween()
					tween.tween_property($MeshInstance3D, "position", Vector3(pos.x, 1.5, pos.z), 1)
					await tween.finished
					currentpos = langelis
					moving = false
		
func shoot_ray():
	var camera = get_viewport().get_camera_3d()
	var mouse_pos = get_viewport().get_mouse_position()
	var ray_length = 1000
	var from = camera.project_position(mouse_pos, 0.0)
	var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	var ray_query = PhysicsRayQueryParameters3D.create(from,to)
	var raycast_result = get_world_3d().direct_space_state.intersect_ray(ray_query)
	var selection = map_selection(raycast_result)
	#print(selection)
	return selection

func map_selection(selection: Dictionary):
	if selection.is_empty():
		return
	if selection["collider"] is GridMap:
		var gridmap: GridMap = selection["collider"]
		var locsel = to_local(selection.position)
		var pos = gridmap.local_to_map(locsel)
		#var selection_normal: Vector3 = selection.normal
		#if selection_normal == Vector3.RIGHT or selection_normal == Vector3.BACK:
			#pos += -Vector3i(selection_normal) + Vector3i.UP
		#elif selection_normal == Vector3.FORWARD or selection_normal == Vector3.LEFT:
			#pos += Vector3i.UP
		return pos

func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		click = true
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and !selected and !moving:
			selected = true
			redraw = true
		elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and selected and !moving:
			selected = false
			redraw = true
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
			click = false
