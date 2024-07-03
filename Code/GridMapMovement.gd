extends GridMap

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")

@export var playermovementPoints = 4
@export var enemymovementPoints = 3
@export var enemyattackrange = 2

var selected = false
var pcurrentpos
var ecurrentpos
var moving = false
var redraw = false
var click = false
var cells
var movemcellls: Array = []
@onready var player = $player
@onready var enemy = $enemy
@onready var sprite = %Sprite3D
@onready var langeliai = $Node3D

func _ready():
	player.position = Vector3(1,1.5,15)
	var pos = local_to_map(Vector3(1,1.5,15))
	pcurrentpos = pos
	enemy.position = Vector3(1,1.5,-15)
	pos = local_to_map(Vector3(1,1.5,-15))
	ecurrentpos = pos
	cells = get_used_cells()
	
func _process(delta):
	if redraw:
		if selected:
			redraw = false
			var pos = map_to_local(pcurrentpos)
			var possprite = pos + Vector3(0,0.01,0)
			sprite.position = possprite
			#draw around
			for i in range(1, playermovementPoints+1):
				var mappos = pcurrentpos + Vector3i(0,0,i)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					langeliai.add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for i in range(1, playermovementPoints+1):
				var mappos = pcurrentpos + Vector3i(0,0,-i)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					langeliai.add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for i in range(1, playermovementPoints+1):
				var mappos = pcurrentpos + Vector3i(i,0,0)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					langeliai.add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for i in range(1, playermovementPoints+1):
				var mappos = pcurrentpos + Vector3i(-i,0,0)
				if cells.has(mappos):
					var pos2 = map_to_local(mappos)
					pos2 += Vector3(0,0.01,0)
					var lang = langelis.instantiate()
					langeliai.add_child(lang)
					lang.position = pos2
					movemcellls.append(mappos)
			for y in range(1, playermovementPoints+1):
				for i in range(1, playermovementPoints+1):
					var mappos = pcurrentpos + Vector3i(y,0,i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						langeliai.add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			for y in range(1, playermovementPoints+1):
				for i in range(1, playermovementPoints+1):
					var mappos = pcurrentpos + Vector3i(-y,0,-i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						langeliai.add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			for y in range(1, playermovementPoints+1):
				for i in range(1, playermovementPoints+1):
					var mappos = pcurrentpos + Vector3i(-y,0,i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						langeliai.add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			for y in range(1, playermovementPoints+1):
				for i in range(1, playermovementPoints+1):
					var mappos = pcurrentpos + Vector3i(y,0,-i)
					if cells.has(mappos):
						var pos2 = map_to_local(mappos)
						pos2 += Vector3(0,0.01,0)
						var lang = langelis.instantiate()
						langeliai.add_child(lang)
						lang.position = pos2
						movemcellls.append(mappos)
			selected = true
		if !selected:
			redraw = false
			sprite.position = Vector3(0,0,0)
			for i in range(1, langeliai.get_child_count()):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
			selected = false
		
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
					tween.tween_property(player, "position", Vector3(pos.x, 1.5, pos.z), 1)
					await tween.finished
					pcurrentpos = langelis
					moving = false
					enemyMove()
					
	
		
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
			
func enemyMove():
	var ppos = pcurrentpos
	var epos = ecurrentpos
	var atstumasx = ppos.x - epos.x
	var atstumasz = ppos.z - epos.z
	var movx = ecurrentpos.x
	var movz = ecurrentpos.z
	
	if abs(atstumasx) > enemyattackrange || abs(atstumasz) > enemyattackrange:
		if abs(atstumasx) > enemyattackrange:	
			if abs(atstumasx) <= enemymovementPoints+enemyattackrange:
				if atstumasx > 0:
					movx = epos.x + (abs(atstumasx)-enemyattackrange)
				if atstumasx < 0:
					movx = epos.x - (abs(atstumasx)-enemyattackrange)
			else:
				if atstumasx > 0:
					movx = epos.x + enemymovementPoints
				if atstumasx < 0:
					movx = epos.x - enemymovementPoints
		if  abs(atstumasz) > enemyattackrange:
			if  abs(atstumasz) <= enemymovementPoints+enemyattackrange:	
				if atstumasz > 0:
					movz = epos.z + (abs(atstumasz)-enemyattackrange)
				if atstumasz < 0:
					movz = epos.z - (abs(atstumasz)-enemyattackrange)                                
			else:
				if atstumasz > 0:
					movz = epos.z + enemymovementPoints
				if atstumasz < 0:
					movz = epos.z - enemymovementPoints
	var locsel = map_to_local(Vector3(movx,0,movz))
	var tween = create_tween()
	tween.tween_property(enemy, "position", Vector3(locsel.x, 1.5, locsel.z), 1)
	await tween.finished
	ecurrentpos = Vector3(movx,0,movz) 

		
		
