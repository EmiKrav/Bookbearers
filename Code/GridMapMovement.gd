extends GridMap

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")

@export var playermovementPoints = 4
@export var enemymovementPoints = 3
@export var enemyattackrange = 2

var selected = false
var pcurrentpos : Vector3i
var ecurrentpos: Vector3i
var ecurrentpos2: Vector3i
var ecurrentpos3: Vector3i
var ecurrentpos4: Vector3i
var moving = false
var redraw = false
var click = false
var cells
var movemcellls: Array = [Vector3i()]
var turn = true
@onready var player = $player
@onready var enemy = $enemy
@onready var enemy2 = $enemy2
@onready var enemy3 = $enemy3
@onready var enemy4 = $enemy4
@onready var sprite = %Sprite3D
@onready var langeliai = $Node3D

func _ready():
	player.position = Vector3(1,1.5,15)
	var pos = local_to_map(Vector3(1,1.5,15))
	pcurrentpos = pos
	enemy.position = Vector3(1,1.5,-15)
	pos = local_to_map(Vector3(1,1.5,-15))
	ecurrentpos = pos
	enemy2.position = Vector3(-1,1.5,-15)
	pos = local_to_map(Vector3(-1,1.5,-15))
	ecurrentpos2 = pos
	enemy3.position = Vector3(1,1.5,-12.8)
	pos = local_to_map(Vector3(1,1.5,-12.8))
	ecurrentpos3 = pos
	enemy4.position = Vector3(-1,1.5,-12.8)
	pos = local_to_map(Vector3(-1,1.5,-12.8))
	ecurrentpos4 = pos
	cells = get_used_cells()
	
func _process(delta):
	if redraw:
		if selected:
			redraw = false
			var pos = map_to_local(pcurrentpos)
			var possprite = pos + Vector3(0,0.01,0)
			sprite.position = possprite
			showMovement()
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
					turn = false
					ecurrentpos = await enemyMove(ecurrentpos, enemy)
					ecurrentpos2 = await enemyMove(ecurrentpos2, enemy2)
					ecurrentpos3 = await enemyMove(ecurrentpos3, enemy3)
					ecurrentpos4 = await enemyMove(ecurrentpos4, enemy4)
					turn = true
					
	
		
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
	if turn:
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
			
func enemyMove(ecurrentposi, enemyi):
	if !turn:
		var othenemypos: Array = [Vector3i()]
		var ppos = pcurrentpos
		var epos = ecurrentposi
		var atstumasx = ppos.x - epos.x
		var atstumasz = ppos.z - epos.z
		var movx = ecurrentposi.x
		var movz = ecurrentposi.z
		var paieskax
		var paieskaz
		
		othenemypos.append(ecurrentpos)
		othenemypos.append(ecurrentpos2)
		othenemypos.append(ecurrentpos3)
		othenemypos.append(ecurrentpos4)
		othenemypos.erase(ecurrentposi)
#1 simple movement
		if abs(atstumasx) > enemyattackrange || abs(atstumasz) > enemyattackrange:
			if abs(atstumasx) > enemyattackrange:	
				if abs(atstumasx) <= enemymovementPoints + enemyattackrange:
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
				if  abs(atstumasz) <= enemymovementPoints + enemyattackrange:	
					if atstumasz > 0:
						movz = epos.z + (abs(atstumasz)-enemyattackrange)
					if atstumasz < 0:
						movz = epos.z - (abs(atstumasz)-enemyattackrange)                                
				else:
					if atstumasz > 0:
						movz = epos.z + enemymovementPoints
					if atstumasz < 0:
						movz = epos.z - enemymovementPoints
		else:
			ecurrentposi = ecurrentposi
		print(enemyi)
		if  !othenemypos.has(Vector3i(movx,0,movz)) and Vector3i(movx,0,movz) != pcurrentpos and cells.has(Vector3i(movx,0,movz)):
			ecurrentposi = Vector3i(movx,0,movz) 
			
		else:
			#2 choose space near optimal
			var atstumasnx = ppos.x - movx
			var atstumasnz = ppos.z - movz
			var ejimuskx = enemymovementPoints - abs((atstumasx - atstumasnx))
			var ejimuskz = enemymovementPoints - abs((atstumasz - atstumasnz))
			for i in range(1,ejimuskx+1):
				if atstumasnx >= 0:
					movx = movx + 1
					if  !othenemypos.has(Vector3i(movx,0,movz)) and Vector3i(movx,0,movz) != pcurrentpos and cells.has(Vector3i(movx,0,movz)):
						ecurrentposi = Vector3i(movx,0,movz) 
						break
				if atstumasnx < 0:
					movx = movx - 1
					if  !othenemypos.has(Vector3i(movx,0,movz)) and Vector3i(movx,0,movz) != pcurrentpos and cells.has(Vector3i(movx,0,movz)):
						ecurrentposi = Vector3i(movx,0,movz) 
						break
			if  othenemypos.has(Vector3i(movx,0,movz)) || Vector3i(movx,0,movz) == pcurrentpos || !cells.has(Vector3i(movx,0,movz)):
				for i in range(1,ejimuskz+1):
					if atstumasnz >= 0:
							movz = movz + 1
							if  !othenemypos.has(Vector3i(movx,0,movz)) and Vector3i(movx,0,movz) != pcurrentpos and cells.has(Vector3i(movx,0,movz)):
								ecurrentposi = Vector3i(movx,0,movz) 
								break
					if atstumasnz < 0:
							movz = movz - 1
							if  !othenemypos.has(Vector3i(movx,0,movz)) and Vector3i(movx,0,movz) != pcurrentpos and cells.has(Vector3i(movx,0,movz)):
								ecurrentposi = Vector3i(movx,0,movz) 
								break
			var threefailed = true
			#3 choose diagonal space near optimal
			if  othenemypos.has(Vector3i(movx,0,movz)) || Vector3i(movx,0,movz) == pcurrentpos || !cells.has(Vector3i(movx,0,movz)):
				if atstumasnx >= 0:
					paieskax = -1
				if atstumasnx < 0:
					paieskax = 1
				if atstumasnz >= 0:
					paieskaz = -1
				if atstumasnz < 0:
					paieskaz = 1
				for y in range(1, ejimuskz+1):
					for i in range(1, ejimuskx+1):
						var mappos = Vector3i(movx,0,movz) + Vector3i(paieskax*y,0,paieskaz*i)
						if  !othenemypos.has(mappos) and mappos != pcurrentpos and cells.has(mappos):
							ecurrentposi = mappos
							threefailed = false
							break
				
				#4 recallculate optimal by changing starting space
				if othenemypos.has(ecurrentposi) || ecurrentposi == pcurrentpos || !cells.has(ecurrentposi) || threefailed:	
					enemyMove(Vector3i(ecurrentposi.x - paieskax,0,ecurrentposi.z - paieskaz), enemyi)
					
		var locsel = map_to_local(Vector3(ecurrentposi.x,0,ecurrentposi.z))
		var tween = create_tween()
		tween.tween_property(enemyi, "position", Vector3(locsel.x, 1.5, locsel.z), 1)
		await tween.finished
		
		return ecurrentposi
		

func showMovement():
#draw around
	movemcellls.clear()
	for i in range(1, playermovementPoints+1):
		var mappos = pcurrentpos + Vector3i(0,0,i)
		if cells.has(mappos):
			movemcellls.append(mappos)
	for i in range(1, playermovementPoints+1):
		var mappos = pcurrentpos + Vector3i(0,0,-i)
		if cells.has(mappos):
			movemcellls.append(mappos)
	for i in range(1, playermovementPoints+1):
		var mappos = pcurrentpos + Vector3i(i,0,0)
		if cells.has(mappos):
			movemcellls.append(mappos)
	for i in range(1, playermovementPoints+1):
		var mappos = pcurrentpos + Vector3i(-i,0,0)
		if cells.has(mappos):
			movemcellls.append(mappos)
#apacia desine
	for y in range(1, playermovementPoints+1):
		for i in range(1, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(y,0,i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#virsus kaire
	for y in range(1, playermovementPoints+1):
		for i in range(1, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(-y,0,-i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#apacia kaire
	for y in range(1, playermovementPoints+1):
		for i in range(1, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(-y,0,i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#virsus desine
	for y in range(1, playermovementPoints+1):
		for i in range(1, playermovementPoints+1):
			var mappos = pcurrentpos + Vector3i(y,0,-i)
			if cells.has(mappos):
				movemcellls.append(mappos)
				
	if movemcellls.has(ecurrentpos):
		movemcellls.erase(ecurrentpos)
	if movemcellls.has(ecurrentpos2):
		movemcellls.erase(ecurrentpos2)
	if movemcellls.has(ecurrentpos3):
		movemcellls.erase(ecurrentpos3)
	if movemcellls.has(ecurrentpos4):
		movemcellls.erase(ecurrentpos4)
		
	for i in movemcellls:
		var pos2 = map_to_local(i)
		pos2 += Vector3(0,0.01,0)
		var lang = langelis.instantiate()
		langeliai.add_child(lang)
		lang.position = pos2
