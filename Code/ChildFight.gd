extends GridMap

@onready var stolenobject = preload("res://Bookbearers/Scenes/stolenobject.tscn")

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")
@onready var zemelapis = preload("res://Bookbearers/Scenes/zemelapis.tscn")
@onready var mirtis = preload("res://Bookbearers/Scenes/dead.tscn")
@onready var langeliomat = preload("res://Bookbearers/Materials/langelis.tres")

@export var maxplayermovementPoints = 4
var playermovementPointsx = maxplayermovementPoints
var playermovementPointsz = maxplayermovementPoints
@export var playerattackrange = 3
@export var playerhealth = 1
@export var enemymovementPoints = 3
@export var enemyattackrange = 2

@export var questnr = Global.currentquest

@onready var menu = preload("res://Bookbearers/Scenes/menuback.tscn")
var paused = false

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
var movemcellls: Array
var othenemypos: Array
var turn = true
var canmove = true
var skill = false
var skillusage = true
var skill2 = false
var skillusage2 = true
var skilling = true
var turnssurvived = 0
var dodge = false
var invisible = false
var nearobj = false

var treeposition = null
var chippossition = null

@onready var player = $player
@onready var enemy = $enemy
@onready var enemy2 = $enemy2
@onready var enemy3 = $enemy3
@onready var enemy4 = $enemy4

@onready var langeliai = $Node3D

var chests = []
var collect = false
var chestcurrent = null
var chestcurrentlabel = null
var endturn = false
var spacepressed = false


@onready var enemyattackanim = preload("res://Bookbearers/Cinematic/zandarasvsvaikas.tscn")
@onready var vaikasdodge = preload("res://Bookbearers/Cinematic/childdodge.tscn")

var randomnrz = [-15, -13, -11, -9, -7, -5, -3, -1]
var randomnrx = [15, 13, 11, 9, 7, 5, 3, 1, -1, -3, -5, -7, -9, -11, -13, -15]
var randomnrzz = [-15, -13, -11, -9, -7, -5, -3, -1, 15, 13, 11, 9, 7, 5, 3, 1]
var ches2x = [-18, -16, -14, -12, -10, -8, -6, -4, -2, 0, 2]
var ches2z = [-8, -6, -4, -2, 0, 2, 4]
var ches1x = [-2, 0, 2, 4, 6, 8, 10, 12, 14, 16, 18]
var ches1z = [-12, -10, -8, -6, -4, -2 ,0]
var ches3x = [-6, -4, -2, 0, 2, 4, 6, 8]
var ches3z = [-16, -14, -12, -10, -8, -6, -4, -2, 0, 2, 4]
var ches4x = [-6, -4, -2, 0, 2, 4, 6, 8]
var ches4z = [16, 14, 12, 10, 8, 6, 4, 2, 0, -2, -4]
var ches5x = [-8, -6, -4, -2, 0, 2, 4, 6, 8, 10]
var ches5z = [14, 12, 10, 8, 6, 4, 2, 0, -2, -4, -6]

func _ready():
	Music.SoundStop()
	if Music.sk != 5:
		Music.play5()
	player.position = Vector3(1,1.5,15)
	var pos = local_to_map(Vector3(1,0,15))
	pcurrentpos = pos
	var rx = randomnrx.pick_random()
	var rz = randomnrz.pick_random()
	enemy.position = Vector3(rx,2,rz)
	pos = local_to_map(Vector3(rx,1.5,rz))
	ecurrentpos = pos
	rx = randomnrx.pick_random()
	rz = randomnrz.pick_random()
	enemy2.position = Vector3(rx,2,rz)
	pos = local_to_map(Vector3(rx,1.5,rz))
	ecurrentpos2 = pos
	while(ecurrentpos2 == ecurrentpos):
		rx = randomnrx.pick_random()
		rz = randomnrz.pick_random()
		enemy2.position = Vector3(rx,2,rz)
		pos = local_to_map(Vector3(rx,1.5,rz))
		ecurrentpos2 = pos
	rx = randomnrx.pick_random()
	rz = randomnrz.pick_random()
	enemy3.position = Vector3(rx,2,rz)
	pos = local_to_map(Vector3(rx,1.5,rz))
	ecurrentpos3 = pos
	while(ecurrentpos3 == ecurrentpos or ecurrentpos3 == ecurrentpos2):
		rx = randomnrx.pick_random()
		rz = randomnrz.pick_random()
		enemy3.position = Vector3(rx,2,rz)
		pos = local_to_map(Vector3(rx,1.5,rz))
		ecurrentpos3 = pos
	rx = randomnrx.pick_random()
	rz = randomnrz.pick_random()
	enemy4.position = Vector3(rx,2,rz)
	pos = local_to_map(Vector3(rx,1.5,rz))
	ecurrentpos4 = pos
	while(ecurrentpos4 == ecurrentpos or ecurrentpos4 == ecurrentpos2 or ecurrentpos4 == ecurrentpos3):
		rx = randomnrx.pick_random()
		rz = randomnrz.pick_random()
		enemy4.position = Vector3(rx,2,rz)
		pos = local_to_map(Vector3(rx,1.5,rz))
		ecurrentpos4 = pos
	var cx = ches2x.pick_random()
	var cz = ches2z.pick_random()
	while((cx == -8 and cz == 2 ) or (cx == -12 and cz == 4)):
		cx = ches2x.pick_random()
		cz = ches2z.pick_random()
	$Chests/Chest2.position.x += cx
	$Chests/Chest2.position.z += cz
	
	cx = ches1x.pick_random()
	cz = ches1z.pick_random()
	while((cx == 8 and cz == -2 ) or (local_to_map($Chests/Chest1.position) == local_to_map($Chests/Chest2.position))):
		cx = ches1x.pick_random()
		cz = ches1z.pick_random()
	$Chests/Chest1.position.x += cx
	$Chests/Chest1.position.z += cz
	
	cx = ches3x.pick_random()
	cz = ches3z.pick_random()
	while((cx == -2 and cz == -6 ) or (local_to_map($Chests/Chest3.position) == local_to_map($Chests/Chest2.position)) or (local_to_map($Chests/Chest3.position) == local_to_map($Chests/Chest1.position))):
		cx = ches3x.pick_random()
		cz = ches3z.pick_random()
	$Chests/Chest3.position.x += cx
	$Chests/Chest3.position.z += cz
	
	cx = ches4x.pick_random()
	cz = ches4z.pick_random()
	while((cx == -2 and cz == 6 ) or (local_to_map($Chests/Chest4.position) == local_to_map($Chests/Chest3.position)) or (local_to_map($Chests/Chest4.position) == local_to_map($Chests/Chest2.position)) or (local_to_map($Chests/Chest4.position) == local_to_map($Chests/Chest1.position))):
		cx = ches4x.pick_random()
		cz = ches4z.pick_random()
	$Chests/Chest4.position.x += cx
	$Chests/Chest4.position.z += cz
	
	cx = ches5x.pick_random()
	cz = ches5z.pick_random()
	while((cx == 2 and cz == 4 ) or (local_to_map($Chests/Chest5.position) == local_to_map($Chests/Chest4.position)) or (local_to_map($Chests/Chest5.position) == local_to_map($Chests/Chest3.position)) or (local_to_map($Chests/Chest5.position) == local_to_map($Chests/Chest2.position)) or (local_to_map($Chests/Chest5.position) == local_to_map($Chests/Chest1.position))):
		cx = ches4x.pick_random()
		cz = ches4z.pick_random()
	$Chests/Chest5.position.x += cx
	$Chests/Chest5.position.z += cz
	
	cells = get_used_cells()
	othenemypos.clear()
	othenemypos.append(ecurrentpos)
	othenemypos.append(ecurrentpos2)
	othenemypos.append(ecurrentpos3)
	othenemypos.append(ecurrentpos4)
	$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff71"

func playermove(langelistomove):
	Global.cameramove = false
	$"../StaticBody3D2/Camera3D".current = false
	$player/Camera3D2.current = true
	var pos = map_to_local(langelistomove)
	moving = true
	selected = false
	redraw = true
	var prad = pcurrentpos
	Music.playsoundwalking()
	if invisible:
		var tween = create_tween()
		tween.tween_property(player.mesh.material, "albedo_color:a", 1, 1)
		tween.tween_property(player, "position", Vector3(player.position.x,chippossition.y,player.position.z), 1)
		await tween.finished
		tween = create_tween()
		tween.tween_property(player, "position", Vector3(chippossition.x,player.position.y,chippossition.z), 1)
		await tween.finished
		player.get_child(0).top_level = false
		player.get_child(2).top_level = false
		invisible = false
	var tween = create_tween()
	tween.tween_property(player, "position", Vector3(pos.x, 1.5, player.position.z), 1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(player, "position", Vector3(player.position.x, 1.5, pos.z), 1)
	await tween2.finished
	Music.SoundStop()
	$player/Camera3D2.current = false
	$"../StaticBody3D2".position.x = player.position.x - 0.355
	$"../StaticBody3D2".position.y = 3.0
	$"../StaticBody3D2".position.z = player.position.z + 3.0
	$"../StaticBody3D2".rotation = Vector3(-0.5,0,0)
	$"../StaticBody3D2/Camera3D".current = true
	pcurrentpos = langelistomove
	moving = false
	Global.cameramove = true
	var pab = pcurrentpos
	playermovementPointsx -=abs(prad.x-pab.x)
	playermovementPointsz -=abs(prad.z-pab.z)
	if playermovementPointsx <= 0 and playermovementPointsz <= 0:
		canmove = false
func _process(_delta):
	if $"../CanvasLayer/Panel/TextureRect/Label".text == str(5) or Global.autopereiti:
		if Global.grafspot == 4 and !Global.posiblequests[0][3]: 
			Global.posiblequests[0][2] = false
			Global.posiblequests[0][3] = true
			Global.posiblequests[1][2] = true
		if Global.grafspot == 4 and Global.posiblequests[4][2] == true and Global.posiblequests[4][3] == false:
			Global.posiblequests[4][2] = false
			Global.posiblequests[4][3] = true
			Global.posiblequests[5][2] = true
		if Global.grafspot == 14:
			Global.posiblequests[2][2] = false
			Global.posiblequests[2][3] = true
			Global.posiblequests[3][2] = true
		if Global.grafspot == 31 and Global.posiblequests[6][2] == true and Global.posiblequests[6][3] == false: 
			Global.posiblequests[6][2] = false
			Global.posiblequests[6][3] = true
			Global.posiblequests[7][2] = true
		if Global.grafspot == 55 and Global.posiblequests[8][2] == true and Global.posiblequests[8][3] == false:
			Global.posiblequests[8][2] = false
			Global.posiblequests[8][3] = true
			Global.posiblequests[9][2] = true
		get_tree().paused = true;
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_packed(zemelapis)	
	if Global.animationplaying:
		$"../CanvasLayer".visible = false
	if !Global.animationplaying:
		$"../CanvasLayer".visible = true
	if playerhealth <= 0 and !Global.animationplaying:
		get_tree().change_scene_to_packed(mirtis)
	if redraw:
		if selected:
			redraw = false
			showMovement(playermovementPointsx,playermovementPointsz)
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
					playermove(langelistomove)
	if collect:
		if Input.is_action_just_pressed("space"):
			collect = false
			chests.append(chestcurrent)
			playermovementPointsx = -1
			playermovementPointsz = -1
			chestcurrentlabel.visible = false
			var stolenobject = stolenobject.instantiate()
			get_parent().add_child(stolenobject)
			$"../CanvasLayer/Panel/TextureRect/Label".text = str(chests.size())
			chestcurrent = null
			chestcurrentlabel = null
		
func _input(event):
	if Input.is_action_pressed("Esc"):
		if !paused:
			var w = menu.instantiate()
			$".".add_child(w)
			paused = true
			Music.SoundStop()
			Music.MusicStop()
			get_tree().paused = true;
		else:
			get_tree().paused = false;
			if Music.mpaused:
				Music.MusicResume()
			paused = false
	if event is InputEventMouseButton:
		spacepressed = false;
	else:
		spacepressed = true;
		
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

func _on_area_3d_input_event(_camera, event, _position, _normal, _shape_idx):
	if turn && canmove:
		if event is InputEventMouseButton:
			click = true
			langeliomat.albedo_color.a = 1
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and !selected and !moving:
				selected = true
				redraw = true
			elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and selected and !moving:
				selected = false
				redraw = true
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == false:
				click = false
			
func enemyMove(ecurrentposi, enemyi):
	#if player.mesh.material.albedo_color.a == 0:
		#$"../StaticBody3D2/Camera3D".current = false
		#enemyi.get_child(0).current = true
		#var locsel = map_to_local(Vector3(ecurrentposi.x,0,ecurrentposi.z))
		#var tween = create_tween()
		#tween.tween_property(enemyi, "position", Vector3(locsel.x, 2, enemyi.position.z), 1)
		#await tween.finished
		#var tween2 = create_tween()
		#tween2.tween_property(enemyi, "position", Vector3(enemyi.position.x, 2, locsel.z), 1)
		#await tween2.finished
		#enemyi.get_child(0).current = false
		#$"../StaticBody3D2/Camera3D".current = true
		#return ecurrentposi
	if !turn:
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()
		var ppos = pcurrentpos
		if player.mesh.material.albedo_color.a == 0:
			ppos = local_to_map(Vector3(randomnrx.pick_random(),1.5,randomnrzz.pick_random()))
		var epos = ecurrentposi
		var atstumasx = ppos.x - epos.x
		var atstumasz = ppos.z - epos.z
		var movx = ecurrentposi.x
		var movz = ecurrentposi.z
		var paieskax
		var paieskaz
		othenemypos.clear()
		othenemypos.append(ecurrentpos)
		othenemypos.append(ecurrentpos2)
		othenemypos.append(ecurrentpos3)
		othenemypos.append(ecurrentpos4)
		othenemypos.erase(ecurrentposi)
#1 simple movement find optimal position
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
		if  !othenemypos.has(Vector3i(movx,0,movz)) and Vector3i(movx,0,movz) != pcurrentpos and cells.has(Vector3i(movx,0,movz)):
			ecurrentposi = Vector3i(movx,0,movz) 
		else:
			
			
			var atstumasnx = ppos.x - movx
			var atstumasnz = ppos.z - movz
			#var ejimuskx = enemymovementPoints - abs((atstumasx - atstumasnx))
			#var ejimuskz = enemymovementPoints - abs((atstumasz - atstumasnz))

			var twofailed = true
			#2 choose diagonal space near optimal
			if  othenemypos.has(Vector3i(movx,0,movz)) || Vector3i(movx,0,movz) == pcurrentpos || !cells.has(Vector3i(movx,0,movz)):
				if atstumasnx >= 0:
					paieskax = +1
				if atstumasnx < 0:
					paieskax = -1
				if atstumasnz >= 0:
					paieskaz = +1
				if atstumasnz < 0:
					paieskaz = -1
					
				var ejimai: Array = [Vector3i()]
				var atstumai: Array = [Vector3i()]
				ejimai.clear()
				atstumai.clear()
				#for y in range(-ejimuskx, ejimuskx+1):
					#for i in range(-ejimuskz, ejimuskz+1):
						#var mappos = Vector3i(movx,0,movz) + Vector3i(y,0,i)
						#if  !othenemypos.has(mappos) and mappos != pcurrentpos and cells.has(mappos):
							#ejimai.append(mappos)
							#atstumai.append(abs(ppos - mappos))
				#apacia desine
				for y in range(1, enemymovementPoints+1):
					for i in range(1, enemymovementPoints+1):
						var mappos = ecurrentposi + Vector3i(y,0,i)
						if  !othenemypos.has(mappos) and mappos != pcurrentpos and cells.has(mappos):
							ejimai.append(mappos)
							atstumai.append(abs(ppos - mappos))
			#virsus kaire
				for y in range(0, enemymovementPoints+1):
					for i in range(0, enemymovementPoints+1):
						var mappos = ecurrentposi  + Vector3i(-y,0,-i)
						if  !othenemypos.has(mappos) and mappos != pcurrentpos and cells.has(mappos):
							ejimai.append(mappos)
							atstumai.append(abs(ppos - mappos))
			#apacia kaire
				for y in range(0, enemymovementPoints+1):
					for i in range(1, enemymovementPoints+1):
						var mappos = ecurrentposi  + Vector3i(-y,0,i)
						if  !othenemypos.has(mappos) and mappos != pcurrentpos and cells.has(mappos):
							ejimai.append(mappos)
							atstumai.append(abs(ppos - mappos))
			#virsus desine
				for y in range(1, enemymovementPoints+1):
					for i in range(0, enemymovementPoints+1):
						var mappos = ecurrentposi  + Vector3i(y,0,-i)
						if  !othenemypos.has(mappos) and mappos != pcurrentpos and cells.has(mappos):
							ejimai.append(mappos)
							atstumai.append(abs(ppos - mappos))
						
				#for i in ejimai:
					#var pos2 = map_to_local(i)
					#pos2 += Vector3(0,0.01,0)
					#var lang = langelis.instantiate()
					#langeliai.add_child(lang)
					#lang.position = pos2
					#
				#await get_tree().create_timer(5).timeout
				if atstumai.size() != 0:
					var maziaus = atstumai[0]
					for i in atstumai:
						if i.x <= maziaus.x && i.z <= maziaus.z:
							maziaus= i
							if i.x <= enemyattackrange && i.z <= enemyattackrange:
								break
						else:
							if i.x + i.z < maziaus.x + maziaus.z:
								maziaus= i
							elif i.x + i.z == maziaus.x + maziaus.z:
								if abs(i.x - i.z) < abs(maziaus.x - maziaus.z):
									maziaus= i
					
					for i in range(0, langeliai.get_child_count()):
						if langeliai.get_child(i) != null:
							langeliai.get_child(i).queue_free()
					if atstumai.size() != null:
						ecurrentposi = ejimai[atstumai.find(maziaus)]
						twofailed = false
						ejimai.clear()
						atstumai.clear()
				#3 recallculate optimal by changing starting space
				if othenemypos.has(ecurrentposi) || ecurrentposi == pcurrentpos || !cells.has(ecurrentposi) || twofailed:	
					ecurrentposi = await enemyMove(Vector3i(ecurrentposi.x - paieskax,0,ecurrentposi.z - paieskaz), enemyi)
		$"../StaticBody3D2/Camera3D".current = false
		enemyi.get_child(0).current = true
		var locsel = map_to_local(Vector3(ecurrentposi.x,0,ecurrentposi.z))
		if locsel.x != enemyi.position.x or locsel.z != enemyi.position.z:
			Music.playsoundwalking()
			var tween = create_tween()
			tween.tween_property(enemyi, "position", Vector3(locsel.x, 2, enemyi.position.z), 1)
			await tween.finished
			var tween2 = create_tween()
			tween2.tween_property(enemyi, "position", Vector3(enemyi.position.x, 2, locsel.z), 1)
			await tween2.finished
			Music.SoundStop()
		enemyi.get_child(0).current = false
		$"../StaticBody3D2/Camera3D".current = true
		return ecurrentposi
		
func enemyAttack(enemyi):
	$"../StaticBody3D2/Camera3D".current = false
	$player/Camera3D2.current = true
	await get_tree().create_timer(1).timeout
	if dodge == true:
		dodge = false
		var anim1 = vaikasdodge.instantiate()
		$"..".add_child(anim1)
	else:
		var anim1 = enemyattackanim.instantiate()
		$"..".add_child(anim1)
		playerhealth= playerhealth-2
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value += 2
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/1"
	if player != null and playerhealth > 0:
		$player/Camera3D2.current = false
		$"../StaticBody3D2/Camera3D".current = true
	
func showMovement(playermovementPointsx,playermovementPointsz):
#draw around
	movemcellls.clear()
#apacia desine
	for y in range(1, playermovementPointsx+1):
		for i in range(1, playermovementPointsz+1):
			var mappos = pcurrentpos + Vector3i(y,0,i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#virsus kaire
	for y in range(0, playermovementPointsx+1):
		for i in range(0, playermovementPointsz+1):
			var mappos = pcurrentpos + Vector3i(-y,0,-i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#apacia kaire
	for y in range(0, playermovementPointsx+1):
		for i in range(1, playermovementPointsz+1):
			var mappos = pcurrentpos + Vector3i(-y,0,i)
			if cells.has(mappos):
				movemcellls.append(mappos)
#virsus desine
	for y in range(1, playermovementPointsx+1):
		for i in range(0, playermovementPointsz+1):
			var mappos = pcurrentpos + Vector3i(y,0,-i)
			if cells.has(mappos):
				movemcellls.append(mappos)
	
	#if movemcellls.has(ecurrentpos):
	movemcellls.erase(ecurrentpos)
	movemcellls.erase(ecurrentpos2)
	movemcellls.erase(ecurrentpos3)
	movemcellls.erase(ecurrentpos4)
	for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()
	for i in movemcellls:
		var pos2 = map_to_local(i)
		pos2 += Vector3(0,0.01,0)
		var lang = langelis.instantiate()
		langeliai.add_child(lang)
		lang.position = pos2
		lang["material_override"]= langeliomat



func _on_skill_pressed():
	if !moving and skillusage:
		skill = false
		skillusage = false
		dodge = true			
		$"../CanvasLayer/Panel/VBoxContainer/Skill"["self_modulate"] = "ffffff71"
		$"../CanvasLayer/Panel/VBoxContainer/Skill/Label".text = "⌛1/1"


func _on_skill_2_pressed():
	if !moving and skillusage2 and nearobj:
		skill2 = false
		skillusage2 = false
		invisible = true			
		$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff71"
		$"../CanvasLayer/Panel/VBoxContainer/Skill2/Label".text = "⌛1/1"
		player.get_child(0).top_level = true
		player.get_child(2).top_level = true
		chippossition = player.position
		$"../StaticBody3D2/Camera3D".current = false
		$player/Camera3D2.current = true
		var tween = create_tween()
		tween.tween_property(player, "position", Vector3(treeposition.x,player.position.y,treeposition.z), 1)
		tween.tween_property(player, "position", Vector3(treeposition.x,treeposition.y+3.0,treeposition.z), 1)
		tween.tween_property(player.mesh.material, "albedo_color:a", 0, 1)
		await tween.finished
		$player/Camera3D2.current = false
		$"../StaticBody3D2/Camera3D".current = true

func _on_end_turn_pressed():
	if !moving and endturn and !spacepressed:
		Global.cameramove = false
		skillusage = false
		skillusage2 = false
		skill = false
		skill2 = false
		skilling = false
		$"../CanvasLayer/Panel/EndTurn"["self_modulate"] = "ffffff71"
		$"../CanvasLayer/Panel/EndTurn"["disabled"]= true
		turn = false
		if enemy != null:
			ecurrentpos = await enemyMove(ecurrentpos, enemy)
			if !invisible and abs(pcurrentpos.x - ecurrentpos.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos.z) <= enemyattackrange:
				await enemyAttack(enemy)
				await get_tree().create_timer(1).timeout
		if enemy2 != null:
			ecurrentpos2 = await enemyMove(ecurrentpos2, enemy2)
			if !invisible and abs(pcurrentpos.x - ecurrentpos2.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos2.z) <= enemyattackrange:
				await enemyAttack(enemy)
				await get_tree().create_timer(1).timeout
		if enemy3 != null:
			ecurrentpos3 = await enemyMove(ecurrentpos3, enemy3)
			if !invisible and abs(pcurrentpos.x - ecurrentpos3.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos3.z) <= enemyattackrange:
				await enemyAttack(enemy3)
				await get_tree().create_timer(1).timeout
		if enemy4 != null:
			ecurrentpos4 = await enemyMove(ecurrentpos4, enemy4)
			if !invisible and abs(pcurrentpos.x - ecurrentpos4.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos4.z) <= enemyattackrange:
				await enemyAttack(enemy4)
				await get_tree().create_timer(1).timeout
		turn = true
		canmove = true
		skillusage = true
		skillusage2 = true
		$"../CanvasLayer/Panel/EndTurn"["disabled"]= false
		$"../CanvasLayer/Panel/EndTurn"["self_modulate"] = "ffffff"
		$"../CanvasLayer/Panel/VBoxContainer/Skill/Label".text = "⌛0/1"
		$"../CanvasLayer/Panel/VBoxContainer/Skill2/Label".text = "⌛0/1"
		$"../CanvasLayer/Panel/VBoxContainer/Skill"["self_modulate"] = "ffffff"
		if invisible:
			$"../StaticBody3D2/Camera3D".current = false
			$player/Camera3D2.current = true
			var tween = create_tween()
			tween.tween_property(player.mesh.material, "albedo_color:a", 1, 1)
			tween.tween_property(player, "position", Vector3(player.position.x,chippossition.y,player.position.z), 1)
			await tween.finished
			tween = create_tween()
			tween.tween_property(player, "position", Vector3(chippossition.x,player.position.y,chippossition.z), 1)
			await tween.finished
			$player/Camera3D2.current = false
			$"../StaticBody3D2/Camera3D".current = true
			player.get_child(0).top_level = false
			player.get_child(2).top_level = false
		if nearobj:
			$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff"
		Global.cameramove = true
		turnssurvived +=1
		playermovementPointsx = maxplayermovementPoints
		playermovementPointsz = maxplayermovementPoints
		endturn = false
		invisible  = false
		


func _on_area_3d_area_entered(area):
	nearobj = true
	if skillusage2:
		$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff"

func _on_area_3d_area_exited(area):
	nearobj = false
	$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff71"
	invisible = false



func _on_area_3d_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area["collision_layer"] == 4:
		var chestlabel = area.get_parent().get_child(1)
		var chestname = str(area.get_parent().name.substr(5,-1))
		if !chests.has(chestname):
			chestlabel.visible = true
			chestcurrent = chestname
			chestcurrentlabel = chestlabel
			collect = true
	if area["collision_layer"] == 2:
		treeposition = area.get_parent().position


func _on_area_3d_area_shape_exited(area_rid, area, area_shape_index, local_shape_index):
	if area["collision_layer"] == 4:
		area.get_parent().get_child(1).visible = false


func _on_end_turn_mouse_entered():
	selected = false
	redraw = true
	endturn = true;

func _on_end_turn_mouse_exited():
	endturn = false;

func _on_end_turn_button_down():
	endturn = true;

func _on_end_turn_button_up():
	endturn = false;


func _on_skill_mouse_entered():
	selected = false
	redraw = true


func _on_skill_2_mouse_entered():
	selected = false
	redraw = true


func _on_skill_mouse_exited():
	pass # Replace with function body.


func _on_skill_2_mouse_exited():
	pass # Replace with function body.
