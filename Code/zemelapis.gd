extends Node3D

@onready var langelis = preload("res://Bookbearers/Scenes/reqejimolang.tscn")
@onready var fog = preload("res://Bookbearers/Scenes/fog.tscn")
@onready var trees = preload("res://Bookbearers/Scenes/trees.tscn")
@onready var kova = load("res://Bookbearers/Scenes/mapfights.tscn")
@onready var vaikokova = load("res://Bookbearers/Scenes/childSteal.tscn")
@onready var werehouse = load("res://Bookbearers/Scenes/vilkolakionamai.tscn")
@onready var treehouse = load("res://Bookbearers/Scenes/vilkolakionamai.tscn")
@onready var sky = load("res://Bookbearers/Materials/sky.material")

@onready var thinking = load("res://Bookbearers/Scenes/afterfight.tscn")

@onready var langeliai = %lang
@onready var player = %player
@export var maxplayermovementPoints = 2
@export var playermovementPoints = maxplayermovementPoints
@export var playerhealth = Global.health

var changetofight = false
var changetochildfight = false
var changetowerehouse = false
var changetotreehouse = false
var changetometalhouse = false
var changetocamp = false
var changetothinking = false

var V = 65;
var par =[]
var dist = [];
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
	if (!Global.bookbearer):
		$player/Mouse.queue_free()
		$player/child.position.x -= 1.0
	$CanvasLayer/Panel/VBoxContainer2/ProgressBar.value = 10 - Global.health
	$CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label.text = str(playerhealth) + "/10"
	$CanvasLayer/Panel/VBoxContainer2/TextureRect/Label.text = str(Global.usedscrolls)
	sky["albedo_color"] = Color(0, 0, 0, 0)
	$DirectionalLight3D["light_energy"] = 0
	$CanvasLayer/Panel["modulate"] = Color(0, 0, 0)
	
	var tween = create_tween()
	tween.tween_property(sky, "albedo_color", Color(1, 1, 1, 0), 1)
	var tween2 = create_tween()
	tween2.tween_property($DirectionalLight3D, "light_energy", 1, 1)
	var tween3 = create_tween()
	tween3.tween_property($CanvasLayer/Panel, "modulate", Color(1, 1, 1), 1)
	get_tree().paused = false;
	updatequests()
	mainas()
	$CanvasLayer/Panel/TextureRect3/Label.text = "Day " + str(Global.day);
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
	$StaticBody3D2.position.x = player.position.x - 0.355
	$StaticBody3D2.position.z = player.position.z + 2.0
	$StaticBody3D2.rotation = Vector3(-0.5,0,0)
	cells = $GridMap.get_used_cells() + $GridMap2.get_used_cells() + $GridMap3.get_used_cells()
	for i in $GridMap.get_used_cells().size():
		var pos2 = $GridMap.map_to_local($GridMap.get_used_cells()[i])
		pos2 += Vector3(0,1.0,0)
		#var lang = langelis.instantiate()
		#langeliai.add_child(lang)
		#lang.position = pos2
		#lang.get_child(0).text = "G" 
		#lang.get_child(1).text = str(i)
		#lang.get_child(2).text = str($GridMap.get_used_cells()[i])
		var lang = fog.instantiate()
		$Node3D.add_child(lang)
		lang.position = pos2
	for i in $GridMap2.get_used_cells().size():
		var pos2 = $GridMap2.map_to_local($GridMap2.get_used_cells()[i])
		pos2 += Vector3(0,1.0,0)
		#var lang = langelis.instantiate()
		#langeliai.add_child(lang)
		#lang.position = pos2
		#lang.get_child(0).text = "G2" 
		#lang.get_child(1).text = str(i)
		#lang.get_child(2).text = str($GridMap2.get_used_cells()[i])
		var lang = fog.instantiate()
		$Node3D.add_child(lang)
		lang.position = pos2
	for i in $GridMap3.get_used_cells().size():
		var pos2 = $GridMap3.map_to_local($GridMap3.get_used_cells()[i])
		pos2 += Vector3(0,1.0,0)
		#var lang = langelis.instantiate()
		#langeliai.add_child(lang)
		#lang.position = pos2
		#lang.get_child(0).text = "G3" 
		#lang.get_child(1).text = str(i)
		#lang.get_child(2).text = str($GridMap3.get_used_cells()[i])
		var lang = fog.instantiate()
		$Node3D.add_child(lang)
		lang.position = pos2
	for i in $GridMap4.get_used_cells().size():
		var pos2 = $GridMap4.map_to_local($GridMap4.get_used_cells()[i])
		pos2 += Vector3(0,0.5,0)
		
		#if pos2.x < 8 && pos2.x > -8:
		var lang = trees.instantiate()
		$Node3D2.add_child(lang)
		lang.position = pos2
	for i in $GridMap5.get_used_cells().size():
		var pos2 = $GridMap5.map_to_local($GridMap5.get_used_cells()[i])
		pos2 += Vector3(0,0.5,0)
		
		#if pos2.x < 8 && pos2.x > -8:
		var lang = trees.instantiate()
		$Node3D2.add_child(lang)
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
		#for i in $GridMap4.get_used_cells().size():
			#var pos2 = $GridMap4.map_to_local($GridMap4.get_used_cells()[i])
			#var ppos = %player.position
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -6.0 && ppos.x <= pos2.x +6.0&& ppos.z >= pos2.z -6.0 && ppos.z <= pos2.z +6.0:
				#y.queue_free()
		#for i in $GridMap5.get_used_cells().size():
			#var pos2 = $GridMap5.map_to_local($GridMap5.get_used_cells()[i])
			#var ppos = %player.position
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -4.0 && ppos.x <= pos2.x +4.0 && ppos.z >= pos2.z -6.0 && ppos.z <= pos2.z +6.0:
				#y.queue_free()
	#for i in $Node3D.get_children():
		##print(i.position - player.position)
		#if snapped(i.position.z - player.position.z,0.1) >= snapped(-4.6,0.1) and i.position.x - player.position.x == 0:
			#i.queue_free()
	
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
	if changetofight:
		Global.grafspot = playercurrentgraphspot
		get_tree().change_scene_to_packed(kova)
	if changetothinking:
		Global.grafspot = playercurrentgraphspot
		get_tree().change_scene_to_packed(thinking)
	if	changetochildfight:
		Global.grafspot = playercurrentgraphspot
		get_tree().change_scene_to_packed(vaikokova)
	if changetowerehouse:
		if Input.is_action_just_pressed("space"):
			Global.grafspot = playercurrentgraphspot
			get_tree().change_scene_to_packed(werehouse)
	if changetotreehouse:
		if Input.is_action_just_pressed("space"):
			Global.grafspot = playercurrentgraphspot
			get_tree().change_scene_to_packed(werehouse)
	if changetometalhouse:
		if Input.is_action_just_pressed("space"):
			Global.grafspot = playercurrentgraphspot
			get_tree().change_scene_to_packed(werehouse)
	if changetocamp:
		if Input.is_action_just_pressed("space"):
			Global.grafspot = playercurrentgraphspot
			Global.health = 10
			$CanvasLayer/Panel/VBoxContainer2/ProgressBar.value = 10 - Global.health
			$CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label.text = str(Global.health) + "/10"
			sky["albedo_color"] = Color(0, 0, 0, 0)
			$DirectionalLight3D["light_energy"] = 0
			$CanvasLayer/Panel["modulate"] = Color(0, 0, 0)
			Global.day += 1
			$CanvasLayer/Panel/TextureRect3/Label.text = "Day " + str(Global.day);
			var tween = create_tween()
			tween.tween_property(sky, "albedo_color", Color(1, 1, 1, 0), 1)
			var tween2 = create_tween()
			tween2.tween_property($DirectionalLight3D, "light_energy", 1, 1)
			var tween3 = create_tween()
			tween3.tween_property($CanvasLayer/Panel, "modulate", Color(1, 1, 1), 1)
	
				
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
	if _shape_idx!= 2 && turn && canmove:
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
			pos2 += Vector3(0,0.525,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text = "G" 
			lang.get_child(1).text = str(movemnumb[i])
			lang.get_child(2).text = str(movemcellls[i])
		if $GridMap2.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G2":
			var pos2 = $GridMap2.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.525,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text= "G2"
			lang.get_child(1).text = str(movemnumb[i])
			lang.get_child(2).text = str(movemcellls[i])
		if $GridMap3.get_used_cells().has(movemcellls[i]) and movemGrids[i] == "G3":
			var pos2 = $GridMap3.map_to_local(movemcellls[i])
			pos2 += Vector3(0,0.525,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos2
			lang.get_child(0).text= "G3"
			lang.get_child(1).text = str(movemnumb[i])
			lang.get_child(2).text = str(movemcellls[i])
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
	#canmove = false
	atspaust = false
	var posic 
	var movpoint = 0
	for v in range(1,tra[grafnumr].size()):
		if movpoint < maxplayermovementPoints - 1:
			movpoint += 1
		if grafas[tra[grafnumr][v]][4] == "G":
			posic = $GridMap.map_to_local(Vector3i(grafas[tra[grafnumr][v]][3][0],grafas[tra[grafnumr][v]][3][1],grafas[tra[grafnumr][v]][3][2]))
		elif grafas[tra[grafnumr][v]][4] == "G2":
			posic = $GridMap2.map_to_local(Vector3i(grafas[tra[grafnumr][v]][3][0],grafas[tra[grafnumr][v]][3][1],grafas[tra[grafnumr][v]][3][2]))
		elif grafas[tra[grafnumr][v]][4] == "G3":
			posic = $GridMap3.map_to_local(Vector3i(grafas[tra[grafnumr][v]][3][0],grafas[tra[grafnumr][v]][3][1],grafas[tra[grafnumr][v]][3][2]))
		
		
		playercurrentgraphspot = tra[grafnumr][v]
		Global.grafspot = playercurrentgraphspot
		
		var tween = create_tween()
		tween.tween_property(player, "position", Vector3(posic.x, 1, posic.z), 1)
		await tween.finished
		#print(movpoint)
		playermovementPoints -= movpoint
	#var tween = create_tween()
	#tween.tween_property(player, "position", Vector3(pos.x, 1, pos.z), 1)
	#await tween.finished
	$player/Camera3D2.current = false
	$StaticBody3D2.position.x = player.position.x - 0.355
	$StaticBody3D2.position.z = player.position.z + 2.0
	$StaticBody3D2.rotation = Vector3(-0.5,0,0)
	$"StaticBody3D2/Camera3D".current = true
	pcurrentpos = langelistomove
	moving = false
	playercurrentgraphspot = grafnumr
	Global.grafspot = playercurrentgraphspot
	mainas()
	#if playercurrentgraphspot == 8:
		#player.position.z+=0.5
		#$VilkoNamai/Label3D.visible = true;
		#changetowerehouse = true
	#if playercurrentgraphspot == 30:
		#$EglesNamai/Label3D.visible = true;
		#changetotreehouse = true
	#if playercurrentgraphspot == 51:
		#$RobotoNamai/Label3D.visible = true;
		#changetometalhouse = true
	for i in range(0, V):
		if dist[i] <= maxplayermovementPoints:
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
	var ppos = %player.position
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
		#for i in $GridMap.get_used_cells().size():
			#var pos2 = $GridMap.map_to_local($GridMap.get_used_cells()[i])
			#var ppos = %player.position
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -4.0 && ppos.x <= pos2.x + 4.0 && ppos.z >= pos2.z -6.0 && ppos.z <= pos2.z + 6.0:
				#y.queue_free()
		#for i in $GridMap2.get_used_cells().size():
			#var pos2 = $GridMap2.map_to_local($GridMap2.get_used_cells()[i])
			#var ppos = %player.position
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -4.0 && ppos.x <= pos2.x + 4.0 && ppos.z >= pos2.z -4.0 && ppos.z <= pos2.z + 4.0:
				#y.queue_free()
		#for i in $GridMap3.get_used_cells().size():
			#var pos2 = $GridMap3.map_to_local($GridMap3.get_used_cells()[i])
			#var ppos = %player.position
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -4.0 && ppos.x <= pos2.x + 4.0 && ppos.z >= pos2.z -4.0 && ppos.z <= pos2.z + 4.0:
				#y.queue_free()
		#for i in $GridMap4.get_used_cells().size():
			#var pos2 = $GridMap4.map_to_local($GridMap4.get_used_cells()[i])
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -4.0 && ppos.x <= pos2.x + 4.0 && ppos.z >= pos2.z -4.0 && ppos.z <= pos2.z + 4.0:
				#y.queue_free()
		#for i in $GridMap5.get_used_cells().size():
			#var pos2 = $GridMap5.map_to_local($GridMap5.get_used_cells()[i])
			#if pos2.x == y.position.x and pos2.z == y.position.z && ppos.x >= pos2.x -4.0 && ppos.x <= pos2.x + 4.0 && ppos.z >= pos2.z -4.0 && ppos.z <= pos2.z + 4.0:
				#y.queue_free()
func _on_texture_rect_pressed():
	if !moving:
		canmove = false
		skillusage = false
		skill = false
		skilling = false
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()
		$"CanvasLayer/Panel/TextureRect"["self_modulate"] = "ffffff71"
		$"CanvasLayer/Panel/TextureRect"["disabled"]= true
		#$DirectionalLight3D["light_energy"] = 0;
		var tween = create_tween()
		tween.tween_property(sky, "albedo_color", Color(0, 0, 0, 0), 1)
		var tween2 = create_tween()
		tween2.tween_property($DirectionalLight3D, "light_energy", 0, 1)
		var tween3 = create_tween()
		tween3.tween_property($CanvasLayer/Panel, "modulate", Color(0, 0, 0), 1)
		await tween.finished
		await get_tree().create_timer(1.0).timeout
		tween = create_tween()
		Global.day+=1;
		$CanvasLayer/Panel/TextureRect3/Label.text = "Day " + str(Global.day);
		tween.tween_property(sky, "albedo_color", Color(1, 1, 1, 0), 1)
		tween2 = create_tween()
		tween2.tween_property($DirectionalLight3D, "light_energy", 1, 1)
		tween3 = create_tween()
		tween3.tween_property($CanvasLayer/Panel, "modulate", Color(1, 1, 1), 1)
		await tween.finished
		turn = false
		turn = true
		skillusage = true
		$"CanvasLayer/Panel/TextureRect"["disabled"]= false
		$"CanvasLayer/Panel/TextureRect"["self_modulate"] = "ffffff"
		playermovementPoints = maxplayermovementPoints
		canmove = true
func  minDistance(dist, sptSet):
	var mini = 9223372036854775807
	var min_index = -1
	for v in range(0, V):
		if (sptSet[v] == false && dist[v] <= mini):
			mini = dist[v];
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

func updatequests():
	Global.quests = null;
	for i in Global.posiblequests.size():
		if Global.posiblequests[i][2] == true:
			if Global.quests != null:
				Global.quests += Global.posiblequests[i][1]
				Global.questheight += 80
			else:
				Global.quests = Global.posiblequests[i][1]
	if Global.quests != null:
		$CanvasLayer/Panel/VBoxContainer/TextureRect2.texture.height = Global.questheight
		$CanvasLayer/Panel/VBoxContainer/TextureRect2/VBoxContainer/RichTextLabel.text = str(Global.quests)
		if Global.questnr.has(0) or Global.questnr.has(4):
			$QuestEnemies/questenemy.visible = true;
		else:
			$QuestEnemies/questenemy.visible = false;
		if Global.questnr.has(2):
			$QuestEnemies/questenemy2.visible = true;
		else:
			$QuestEnemies/questenemy2.visible = false;
func _on_were_house_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot == 8:
		$VilkoNamai/Label3D.visible = true;
		changetowerehouse = true;
func _on_were_house_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot != 8:
		$VilkoNamai/Label3D.visible = false;
		changetowerehouse = false;
func _on_tree_house_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot == 30:
		$EglesNamai/Label3D.visible = true;
		changetotreehouse = true
func _on_tree_house_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot != 30:
		$EglesNamai/Label3D.visible = false;
		changetotreehouse = false
func _on_metal_house_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot == 51:
		$RobotoNamai/Label3D.visible = true;
		changetometalhouse = true
func _on_metal_house_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if playercurrentgraphspot != 51:
		$RobotoNamai/Label3D.visible = false;
		changetometalhouse = false


func _on_camp_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	changetocamp = true
	if playercurrentgraphspot == 13:
		$Camps/Camp/Label3D.visible = true
	if playercurrentgraphspot == 17:
		$Camps/Camp2/Label3D.visible = true
	if playercurrentgraphspot == 39:
		$Camps/Camp3/Label3D.visible = true
	if playercurrentgraphspot == 57:
		$Camps/Camp4/Label3D.visible = true

func _on_camp_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	changetocamp = false
	$Camps/Camp/Label3D.visible = false
	$Camps/Camp2/Label3D.visible = false
	$Camps/Camp3/Label3D.visible = false
	$Camps/Camp4/Label3D.visible = false
	


func _on_mouse_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area["collision_layer"] == 32 and area.get_parent().visible == true:
		changetochildfight = true
	if area["collision_layer"] == 8:
		Global.scrolls.append(area.get_parent().get_child(1)["text"])
		Global.usedscrolls +=1;
		$CanvasLayer/Panel/VBoxContainer2/TextureRect/Label.text = str(Global.usedscrolls)
		area.get_parent().queue_free()
	if area["collision_layer"] == 2:
		if Global.bookbearer:
			Global.enemy.append(area.get_parent().get_child(1)["text"])
			changetofight = true
		else:
			changetothinking = true;
