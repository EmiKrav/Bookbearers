extends Node3D

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")

@onready var langeliai = %lang
@onready var player = %player
@export var playermovementPoints = 4
@export var playerattackrange = 3
@export var playerhealth = 10

var selected = false
var pcurrentpos : Vector3i
var moving = false
var redraw = false
var click = false
var cells
var cells2
var movemcellls: Array
var othenemypos: Array
var turn = true
var canmove = true
var skill = false
var skillusage = true
var skilling = true

func _ready():
	player.position = Vector3(0.2,1.5,5)
	var pos = $GridMap.local_to_map(Vector3(0.2,1,5))
	pcurrentpos = pos
	cells = $GridMap.get_used_cells() + $GridMap2.get_used_cells() + $GridMap3.get_used_cells()
	
	
func _process(_delta):
	if redraw:
		if selected:
			redraw = false
			showMovement()
			selected = true
		if !selected:
			redraw = false
			for i in range(0, langeliai.get_child_count()):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
			selected = false
		
	if !click && !moving && selected:
		if Input.is_action_pressed("Click"):
			if shoot_ray() != null:
				var langelistomove = shoot_ray()
				if movemcellls.has(langelistomove):
					$"StaticBody3D2/Camera3D".current = false
					$player/Camera3D2.current = true
					if $GridMap.get_used_cells().has(langelistomove):
						var pos = $GridMap.map_to_local(langelistomove)
						movethere(pos,langelistomove)
					if $GridMap2.get_used_cells().has(langelistomove):
						var pos = $GridMap2.map_to_local(langelistomove)
						movethere(pos,langelistomove)
					if $GridMap3.get_used_cells().has(langelistomove):
						var pos = $GridMap3.map_to_local(langelistomove)
						movethere(pos,langelistomove)
					

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
		var locsel = to_local(selection.position)
		var pos = gridmap.local_to_map(locsel)
		return pos

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if turn && canmove:
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

func showMovement():
#draw around
	movemcellls.clear()
#apacia desine
	for y in range(1, playermovementPoints+1):
		for i in range(1, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(y,0,i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#virsus kaire
	for y in range(0, playermovementPoints+1):
		for i in range(0, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(-y,0,-i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#apacia kaire
	for y in range(0, playermovementPoints+1):
		for i in range(1, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(-y,0,i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#virsus desine
	for y in range(1, playermovementPoints+1):
		for i in range(0, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(y,0,-i)
			if cells.has(mappos):
				movemcellls.append(mappos)
	
	#if movemcellls.has(ecurrentpos):
	
	for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()
	for i in movemcellls:
		if $GridMap.get_used_cells().has(i):
			var pos2 = $GridMap.map_to_local(i)
			pos2 += Vector3(0,0.605,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
		if $GridMap2.get_used_cells().has(i):
			var pos2 = $GridMap2.map_to_local(i)
			pos2 += Vector3(0,0.605,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
		if $GridMap3.get_used_cells().has(i):
			var pos2 = $GridMap3.map_to_local(i)
			pos2 += Vector3(0,0.605,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2

func movethere(pos, langelistomove):
	moving = true
	selected = false
	redraw = true
	canmove = false
	var tween = create_tween()
	tween.tween_property(player, "position", Vector3(pos.x, 1.5, pos.z), 1)
	await tween.finished
	$player/Camera3D2.current = false
	$"StaticBody3D2/Camera3D".current = true
	pcurrentpos = langelistomove
	moving = false
	
func _on_texture_rect_pressed():
	if !moving:
		skillusage = false
		skill = false
		skilling = false
		$"CanvasLayer/Panel/TextureRect"["self_modulate"] = "ffffff71"
		$"CanvasLayer/Panel/TextureRect"["disabled"]= true
		turn = false
		turn = true
		canmove = true
		skillusage = true
		$"CanvasLayer/Panel/TextureRect"["disabled"]= false
		$"CanvasLayer/Panel/TextureRect"["self_modulate"] = "ffffff"
