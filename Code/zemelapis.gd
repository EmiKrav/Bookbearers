extends Node3D

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")


@onready var langeliai = %lang
@onready var player = %player
@export var playermovementPoints = 1
@export var playerhealth = 10

var V = 22;
var par =[]
var dist = []
var grafas
var tra = []
var playercurrentgraphspot = 0

var selected = false
var pcurrentpos : Vector3i
var moving = false
var redraw = false
var click = false
var cells
var cells2
var movemcellls: Array
var movemGrids: Array
var movemnumb: Array
var othenemypos: Array
var turn = true
var canmove = true
var skill = false
var skillusage = true
var skilling = true

var procesas = false

var paspaus = false
var atspaust = false

func _ready():
	player.position = Vector3(0,1,4.6)
	var pos = $GridMap.local_to_map(Vector3(0,1,4.5))
	pcurrentpos = pos
	cells = $GridMap.get_used_cells() + $GridMap2.get_used_cells() + $GridMap3.get_used_cells()
	mainas()
func _process(delta):
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
	
	

func _input(event):
	if !click && !moving && selected:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and selected and !moving and !click:
				atspaust = true
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false and selected and !moving and !click:
				atspaust = false
				judeti()
func judeti():
	if !click && !moving && selected && !atspaust:	
		print("jo")
		var langelistomove = shoot_ray()
		if langelistomove != null:
			print("1")
			print(langelistomove)
			if movemcellls.has(langelistomove):
				print("2")
				$"StaticBody3D2/Camera3D".current = false
				$player/Camera3D2.current = true
				if $GridMap.get_used_cells().has(langelistomove):
					var pos = $GridMap.map_to_local(langelistomove)
					for i in langeliai.get_child_count():
						if pos == Vector3(langeliai.get_child(i).position.x,pos.y,langeliai.get_child(i).position.z):
							movethere(pos,langelistomove)
							break
				if $GridMap2.get_used_cells().has(langelistomove):
					var pos = $GridMap2.map_to_local(langelistomove)
					for i in langeliai.get_child_count():
						if pos == Vector3(langeliai.get_child(i).position.x,pos.y,langeliai.get_child(i).position.z):
							movethere(pos,langelistomove)
							break
				if $GridMap3.get_used_cells().has(langelistomove):
					var pos = $GridMap3.map_to_local(langelistomove)
					for i in langeliai.get_child_count():
						if pos == Vector3(langeliai.get_child(i).position.x,pos.y,langeliai.get_child(i).position.z):
							movethere(pos,langelistomove)
							break
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
	movemcellls.clear()
	movemGrids.clear()
	movemnumb.clear()
	for i in range(0, V):
		if dist[i] <= playermovementPoints:
			var mapposx = grafas[i][3][0]
			var mapposy = grafas[i][3][1]
			var mapposz = grafas[i][3][2]
			if cells.has(Vector3i(mapposx,mapposy,mapposz)):
				movemcellls.append(Vector3i(mapposx,mapposy,mapposz))
				movemGrids.append(grafas[i][4])
				movemnumb.append(grafas[i][0])
				
	for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()
				
	for i in movemcellls.size():
		if $GridMap.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G":
			var pos2 = $GridMap.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.605,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text = "G" 
			lang.get_child(1).text = str(movemnumb[i])
			print(lang.get_child(1).text)
		if $GridMap2.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G2":
			var pos2 = $GridMap2.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.605,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text= "G2"
			lang.get_child(1).text = str(movemnumb[i])
		if $GridMap3.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G3":
			var pos2 = $GridMap3.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.605,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text= "G3"
			lang.get_child(1).text = str(movemnumb[i])

func movethere(pos, langelistomove):
	moving = true
	selected = false
	redraw = true
	canmove = false
	atspaust = false
	var tween = create_tween()
	tween.tween_property(player, "position", Vector3(pos.x, 1, pos.z), 1)
	await tween.finished
	$player/Camera3D2.current = false
	$"StaticBody3D2/Camera3D".current = true
	pcurrentpos = langelistomove
	moving = false
	if pos == $GridMap.map_to_local(langelistomove):
		for i in grafas:
			if Vector3i(i[3][0],i[3][1],i[3][2]) == langelistomove and i[4] == "G":
				playercurrentgraphspot = i[0]
				print(playercurrentgraphspot)
				mainas()
				break
	if pos == $GridMap2.map_to_local(langelistomove):
		for i in grafas:
			if Vector3i(i[3][0],i[3][1],i[3][2]) == langelistomove and i[4] == "G2":
				playercurrentgraphspot = i[0]
				print(playercurrentgraphspot)
				mainas()
				break
	if pos == $GridMap3.map_to_local(langelistomove):
		for i in grafas:
			if Vector3i(i[3][0],i[3][1],i[3][2]) == langelistomove and i[4] == "G3":
				playercurrentgraphspot = i[0]
				print(playercurrentgraphspot)
				mainas()
				break
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
		
func  minDistance(dist, sptSet):
	var min = 9223372036854775807
	var min_index = -1
	for v in range(0, V):
		if (sptSet[v] == false && dist[v] <= min):
			min = dist[v];
			min_index = v;
			
	return min_index;
	
func Solution(dist,src,near):
	for i in range(0, V):
		#print(src,"->",i,"\t\t ",dist[i])
		par.clear()
		Path(i,near)
		tra.append([])
		#print(par)
		for y in par:
			tra[i].append(y)
		
		
func Path(currentVertex,parents):
	if (currentVertex == null):
		return; 
	Path(parents[currentVertex], parents); 
	par.append(currentVertex)
	#print(currentVertex," "); 
	
func dijekstra(graph, src):
	var sptSet= []
	var near =[]
	dist.clear()
	near.resize(V)
	for i in range(0, V):
		dist.append(9223372036854775807)
		sptSet.append(false)
	
	dist[src] = 0;
	for count in range(0, V-1):
		var u = minDistance(dist, sptSet);
		
		sptSet[u] = true;
		
		for v in range(0, V):
			if (!sptSet[v] and graph[u][v] != 0 and dist[u] != 9223372036854775807 
				and dist[u] + graph[u][v] < dist[v]):
				dist[v] = dist[u] + graph[u][v];
				near[v] = u
	Solution(dist,src,near);
	
func mainas():    
	var number = []
	var file = FileAccess.open("res://Bookbearers/Code/grafas.txt", FileAccess.READ)
	var content = file.get_as_text()
	var salia = str_to_var(content)
	grafas = salia
	#print(salia)
	for b in range(0, V):
		number.append([])
		for i in range(0, V):
			if salia[b][1].has(i):
				number[b].append(salia[b][2][salia[b][1].find(i)])
			else:
				number[b].append(0)
	dijekstra(number, playercurrentgraphspot);
