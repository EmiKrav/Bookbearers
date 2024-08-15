extends Node3D

@onready var langelis = preload("res://Bookbearers/Scenes/reqejimolang.tscn")
@onready var fog = preload("res://Bookbearers/Scenes/fog.tscn")
@onready var kova = load("res://Bookbearers/Scenes/mapfights.tscn")
@onready var werehouse = load("res://Bookbearers/Scenes/vilkolakionamai.tscn")

@onready var langeliai = %lang
@onready var player = %player
@export var playermovementPoints = 2
@export var playerhealth = 10

var changetofight = false
var changetowerehouse = false

var V = 22;
var par =[]
var dist = []
var grafas
var tra = []
var playercurrentgraphspot = Global.grafspot

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
	get_tree().paused = false;
	mainas()
	updatequests()
	
	if Global.grafspot == 5:
		$enemy.queue_free()
	#if Global.grafspot == 8:
		#changetowerehouse =
	if grafas[playercurrentgraphspot][4] == "G":
		player.position =  $GridMap.map_to_local(Vector3i(grafas[playercurrentgraphspot][3][0],grafas[playercurrentgraphspot][3][1],grafas[playercurrentgraphspot][3][2]))
		player.position += Vector3(0,1,0)
	elif grafas[playercurrentgraphspot][4] == "G2":
		player.position =  $GridMap2.map_to_local(Vector3i(grafas[playercurrentgraphspot][3][0],grafas[playercurrentgraphspot][3][1],grafas[playercurrentgraphspot][3][2]))
		player.position += Vector3(0,1,0)
	elif grafas[playercurrentgraphspot][4] == "G3":
		player.position =  $GridMap3.map_to_local(Vector3i(grafas[playercurrentgraphspot][3][0],grafas[playercurrentgraphspot][3][1],grafas[playercurrentgraphspot][3][2]))
		player.position += Vector3(0,1,0)
	var pos = Vector3i(grafas[playercurrentgraphspot][3][0],grafas[playercurrentgraphspot][3][1],grafas[playercurrentgraphspot][3][2])
	pcurrentpos = pos
	cells = $GridMap.get_used_cells() + $GridMap2.get_used_cells() + $GridMap3.get_used_cells()
	for i in $GridMap.get_used_cells().size():
		var pos2 = $GridMap.map_to_local($GridMap.get_used_cells()[i])
		pos2 += Vector3(0,0.5,0)
		var lang = fog.instantiate()
		$Node3D.add_child(lang)
		lang.position = pos2
	for i in $GridMap2.get_used_cells().size():
		var pos2 = $GridMap2.map_to_local($GridMap2.get_used_cells()[i])
		pos2 += Vector3(0,0.5,0)
		var lang = fog.instantiate()
		$Node3D.add_child(lang)
		lang.position = pos2
	for i in $GridMap3.get_used_cells().size():
		var pos2 = $GridMap3.map_to_local($GridMap3.get_used_cells()[i])
		pos2 += Vector3(0,0.5,0)
		var lang = fog.instantiate()
		$Node3D.add_child(lang)
		lang.position = pos2
		
	
	
	for i in range(0, V):
		if dist[i] <= playermovementPoints:
			var mapposx = grafas[i][3][0]
			var mapposy = grafas[i][3][1]
			var mapposz = grafas[i][3][2]
			if !Global.istrynt.has(Vector3i(mapposx,mapposy,mapposz)):
				Global.istrynt.append(Vector3i(mapposx,mapposy,mapposz))
				Global.istryntg.append(grafas[i][4])
			elif Global.istryntg[Global.istrynt.find(Vector3i(mapposx,mapposy,mapposz))] != grafas[i][4]:
				if findfrom(Global.istrynt.find(Vector3i(mapposx,mapposy,mapposz)),grafas[i][4],Vector3i(mapposx,mapposy,mapposz)) == -1:
					Global.istrynt.append(Vector3i(mapposx,mapposy,mapposz))
					Global.istryntg.append(grafas[i][4])
	for y in $Node3D.get_children():
		for i in Global.istrynt.size():
			if $GridMap.get_used_cells().has(Global.istrynt[i]) and Global.istryntg[i] == "G":
				var pos2 = $GridMap.map_to_local(Global.istrynt[i])
				if pos2.x == y.position.x and pos2.z == y.position.z:
					y.queue_free()
			if $GridMap2.get_used_cells().has(Global.istrynt[i]) and Global.istryntg[i] == "G2":
				var pos2 = $GridMap2.map_to_local(Global.istrynt[i])
				if pos2.x == y.position.x and pos2.z == y.position.z:
					y.queue_free()
			if $GridMap3.get_used_cells().has(Global.istrynt[i]) and Global.istryntg[i] == "G3":
				var pos2 = $GridMap3.map_to_local(Global.istrynt[i])
				if pos2.x == y.position.x and pos2.z == y.position.z:
					y.queue_free()		
	#for i in $Node3D.get_children():
		##print(i.position - player.position)
		#if snapped(i.position.z - player.position.z,0.1) >= snapped(-4.6,0.1) and i.position.x - player.position.x == 0:
			#i.queue_free()
	
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
	if changetofight:
		Global.grafspot = playercurrentgraphspot
		get_tree().change_scene_to_packed(kova)
	if changetowerehouse:
		Global.grafspot = playercurrentgraphspot
		get_tree().change_scene_to_packed(werehouse)
				
func judeti(numeris):
		$"StaticBody3D2/Camera3D".current = false
		$player/Camera3D2.current = true
		var langelistomove = Vector3i(grafas[str_to_var(numeris)][3][0],grafas[str_to_var(numeris)][3][1],grafas[str_to_var(numeris)][3][2])
		var ind = str_to_var(numeris)
		var pos
		if grafas[ind][4] == "G":
			pos = $GridMap.map_to_local(langelistomove)
		elif grafas[ind][4] == "G2":
			pos = $GridMap2.map_to_local(langelistomove)
		elif grafas[ind][4] == "G3":
			pos = $GridMap3.map_to_local(langelistomove)
		
		movethere(pos,langelistomove,ind)
		
					

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
			pos2 += Vector3(0,0.5,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text = "G" 
			lang.get_child(1).text = str(movemnumb[i])
		if $GridMap2.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G2":
			var pos2 = $GridMap2.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.5,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text= "G2"
			lang.get_child(1).text = str(movemnumb[i])
		if $GridMap3.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G3":
			var pos2 = $GridMap3.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.5,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text= "G3"
			lang.get_child(1).text = str(movemnumb[i])
func findfrom(ind, com, what):
	if Global.istrynt.find(what,ind+1) != -1:
		if Global.istryntg[Global.istrynt.find(what,ind+1)] != com:
			findfrom(ind,com, what)
		else:
			return 0
	else:
		return -1
func movethere(pos, langelistomove,grafnumr):
	moving = true
	selected = false
	redraw = true
	canmove = false
	atspaust = false
	var posic 
	var movpoint = 0
	for v in range(1,tra[grafnumr].size()):
		movpoint += 1
		if grafas[tra[grafnumr][v]][4] == "G":
			posic = $GridMap.map_to_local(Vector3i(grafas[tra[grafnumr][v]][3][0],grafas[tra[grafnumr][v]][3][1],grafas[tra[grafnumr][v]][3][2]))
		elif grafas[tra[grafnumr][v]][4] == "G2":
			posic = $GridMap2.map_to_local(Vector3i(grafas[tra[grafnumr][v]][3][0],grafas[tra[grafnumr][v]][3][1],grafas[tra[grafnumr][v]][3][2]))
		elif grafas[tra[grafnumr][v]][4] == "G3":
			posic = $GridMap3.map_to_local(Vector3i(grafas[tra[grafnumr][v]][3][0],grafas[tra[grafnumr][v]][3][1],grafas[tra[grafnumr][v]][3][2]))
		var camx = player.position.x - $StaticBody3D2.position.x
		var camz = player.position.z - $StaticBody3D2.position.z
		$StaticBody3D2.position.x = posic.x - camx
		$StaticBody3D2.position.z = posic.z - camz
		playercurrentgraphspot = tra[grafnumr][v]
		Global.grafspot = playercurrentgraphspot
		var tween = create_tween()
		tween.tween_property(player, "position", Vector3(posic.x, 1, posic.z), 1)
		await tween.finished
	if movpoint == 0:
		if playercurrentgraphspot == 8:
			changetowerehouse = true
	
	#var tween = create_tween()
	#tween.tween_property(player, "position", Vector3(pos.x, 1, pos.z), 1)
	#await tween.finished
	$player/Camera3D2.current = false
	$"StaticBody3D2/Camera3D".current = true
	pcurrentpos = langelistomove
	moving = false
	playercurrentgraphspot = grafnumr
	Global.grafspot = playercurrentgraphspot
	mainas()
	for i in range(0, V):
		if dist[i] <= playermovementPoints:
			var mapposx = grafas[i][3][0]
			var mapposy = grafas[i][3][1]
			var mapposz = grafas[i][3][2]
			if !Global.istrynt.has(Vector3i(mapposx,mapposy,mapposz)):
				Global.istrynt.append(Vector3i(mapposx,mapposy,mapposz))
				Global.istryntg.append(grafas[i][4])
			elif Global.istryntg[Global.istrynt.find(Vector3i(mapposx,mapposy,mapposz))] != grafas[i][4]:
				if findfrom(Global.istrynt.find(Vector3i(mapposx,mapposy,mapposz)),grafas[i][4],Vector3i(mapposx,mapposy,mapposz)) == -1:
					Global.istrynt.append(Vector3i(mapposx,mapposy,mapposz))
					Global.istryntg.append(grafas[i][4])
	for y in $Node3D.get_children():
		for i in Global.istrynt.size():
			if $GridMap.get_used_cells().has(Global.istrynt[i]) and Global.istryntg[i] == "G":
				var pos2 = $GridMap.map_to_local(Global.istrynt[i])
				if pos2.x == y.position.x and pos2.z == y.position.z:
					y.queue_free()
			if $GridMap2.get_used_cells().has(Global.istrynt[i]) and Global.istryntg[i] == "G2":
				var pos2 = $GridMap2.map_to_local(Global.istrynt[i])
				if pos2.x == y.position.x and pos2.z == y.position.z:
					y.queue_free()
			if $GridMap3.get_used_cells().has(Global.istrynt[i]) and Global.istryntg[i] == "G3":
				var pos2 = $GridMap3.map_to_local(Global.istrynt[i])
				if pos2.x == y.position.x and pos2.z == y.position.z:
					y.queue_free()			
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
	tra.clear()
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


func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	changetofight = true
func updatequests():
	if Global.quests != null:
		$CanvasLayer/Panel/TextureRect2/VBoxContainer/RichTextLabel.text += str(Global.quests)
		$CanvasLayer/Panel/TextureRect2.texture.height += 10
	


func _on_were_house_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot == 8:
		changetowerehouse = true 
