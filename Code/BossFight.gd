extends GridMap

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")
@onready var zemelapis = preload("res://Bookbearers/Scenes/zemelapis.tscn")
@onready var mirtis = preload("res://Bookbearers/Scenes/dead.tscn")
@onready var langeliomat = preload("res://Bookbearers/Materials/langelis.tres")

@onready var ugnis = preload("res://Bookbearers/Scenes/ugnis.tscn")
@onready var kelmas =  preload("res://Bookbearers/Scenes/kelmas.tscn")

var menu = preload("res://Bookbearers/Scenes/menuback.tscn")
var paused = false
@onready var cinematic = preload("res://Bookbearers/Scenes/paskutinisvideo.tscn")


@export var maxplayermovementPoints = 4
var playermovementPointsx = maxplayermovementPoints
var playermovementPointsz = maxplayermovementPoints
@export var playerattackrange = 3
@export var playerhealth = 1
@export var enemymovementPoints = 0
@export var enemyattackrange = 2

var changetocinematic = false

var selected = false
var pcurrentpos : Vector3i
var ecurrentpos: Vector3i
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

@onready var player = $player
@onready var enemy = $enemy
@onready var langeliai = $Node3D

var spacepressed = false
var endturn = false
var randomnrz = [-15, -13, -11, -9, -7, -5, -3, -1]
var randomnrx = [15, 13, 11, 9, 7, 5, 3, 1, -1, -3, -5, -7, -9, -11, -13, -15]
var randomnrzz = [-15, -13, -11, -9, -7, -5, -3, -1, 15, 13, 11, 9, 7, 5, 3, 1]

var nearchar = false
var nearchar2 = false
var nearchar3 = false
func _ready():
	Music.SoundStop()
	if Music.sk != 5:
		Music.play5()
	#player.position = Vector3(1,1.5,15)
	var pos = local_to_map(player.position)
	pcurrentpos = pos
	enemy.position = Vector3(1,2,-15)
	pos = local_to_map(Vector3(1,2,-15))
	ecurrentpos = pos
	cells = get_used_cells()
	cells.sort()
	othenemypos.clear()
	if Global.posiblequests[9][3] == false:
		$vilkas3.queue_free()
	if Global.posiblequests[7][3] == false:
		$vilkas2.queue_free()
	if Global.posiblequests[5][3] == false:
		$vilkas.queue_free()
	#var kel = -1;
	#for i in cells:
		#kel+=1
		##if i.x == 2 and i.z == 11:
			##$".".set_cell_item(i,-1)
			##break
		##if i.x == -1 and i.z == 2:
			##$".".set_cell_item(i,-1)
			##break
		#if i.x == -2 and i.z == -3:
			#$".".set_cell_item(i,-1)
			#break
	#print(kel)
	#othenemypos.append(ecurrentpos)
	#othenemypos.append(pos)
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
	
	if changetocinematic:
		get_tree().change_scene_to_packed(cinematic)
	
	if playerhealth <= 0:
		if player != null:
			player.queue_free()
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
					
	
		
func _input(event):
	if Input.is_action_pressed("Esc"):
		if !paused:
			var w = menu.instantiate()
			get_parent().add_child(w)
			paused = true
			get_tree().paused = true;
		else:
			get_tree().paused = false;
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
		#othenemypos.clear()
		#othenemypos.append(ecurrentpos)
		#othenemypos.erase(ecurrentposi)
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
		var tween = create_tween()
		tween.tween_property(enemyi, "position", Vector3(locsel.x, 2, enemyi.position.z), 1)
		await tween.finished
		var tween2 = create_tween()
		tween2.tween_property(enemyi, "position", Vector3(enemyi.position.x, 2, locsel.z), 1)
		await tween2.finished
		enemyi.get_child(0).current = false
		$"../StaticBody3D2/Camera3D".current = true
		return ecurrentposi
		
func enemyAttack(enemyi):
	$"../StaticBody3D2/Camera3D".current = false
	$player/Camera3D2.current = true
	await get_tree().create_timer(1).timeout
	if dodge == true:
		dodge = false
	else:
		playerhealth= playerhealth-2
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value += 2
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/1"
	if player != null:
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
	#movemcellls.erase(ecurrentpos)

	#movemcellls.erase(Vetor3(2,1,11))
	if $vilkas != null:
		movemcellls.erase(cells[247])
	if $vilkas2 != null:
		movemcellls.erase(cells[170])
	if $vilkas3 != null:
		movemcellls.erase(cells[142])
	
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
		var tween = create_tween()
		tween.tween_property(player.mesh.material, "albedo_color:a", 0, 1)
		await tween.finished


func _on_end_turn_pressed():
	if !moving and !spacepressed:
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
			#if abs(pcurrentpos.x - ecurrentpos.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos.z) <= enemyattackrange:
				#await enemyAttack(enemy)
			if !nearchar and !nearchar2 and !nearchar3 and (!nearobj or !invisible):
				$"../StaticBody3D2".position.x = player.position.x - 0.355
				$"../StaticBody3D2".position.y = 3.0
				$"../StaticBody3D2".position.z = player.position.z + 3.0
				$"../StaticBody3D2".rotation = Vector3(-0.5,0,0)
				var ugn = ugnis.instantiate()
				get_parent().add_child(ugn)
				ugn.position = player.position
				Music.playsoundfire()
				var tween = create_tween()
				for u in ugn.get_children():
					tween.tween_property(u, "scale",Vector3(2.0,2.0,2.0), 2)
					tween.set_parallel()
				await tween.finished
				Music.SoundStop()
				playerhealth= playerhealth-2
				$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value += 2
				$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/1"
			elif nearobj and invisible:
				var tr
				if $HidingTree != null:
					tr = $HidingTree
				elif $HidingTree2 != null:
					tr = $HidingTree2
				elif $HidingTree3 != null:
					tr = $HidingTree3
				$"../StaticBody3D2".position.x = tr.position.x - 0.355
				$"../StaticBody3D2".position.y = 3.0
				$"../StaticBody3D2".position.z = tr.position.z + 3.0
				$"../StaticBody3D2".rotation = Vector3(-0.5,0,0)
				var ugn = ugnis.instantiate()
				get_parent().add_child(ugn)
				var pozoftree = map_to_local(local_to_map(tr.position))
				ugn.position = map_to_local(local_to_map(tr.position))
				ugn.position.y -= 1.5
				Music.playsoundfire()
				var tween = create_tween()
				for u in ugn.get_children():
					tween.tween_property(u, "scale",Vector3(2.0,2.0,2.0), 5)
					tween.set_parallel()
				await tween.finished
				Music.SoundStop()
				ugn.queue_free()
				tr.queue_free()
				var kelmas = kelmas.instantiate()
				get_parent().add_child(kelmas)
				kelmas.position = pozoftree
				kelmas.position.y -= 2.0
				nearobj = false
				invisible = false
			elif nearchar:
				$"../StaticBody3D2".position.x = $vilkas.position.x - 0.355
				$"../StaticBody3D2".position.y = 3.0
				$"../StaticBody3D2".position.z = $vilkas.position.z + 3.0
				$"../StaticBody3D2".rotation = Vector3(-0.5,0,0)
				var ugn = ugnis.instantiate()
				get_parent().add_child(ugn)
				ugn.position = map_to_local(local_to_map($vilkas.position))
				ugn.position.y -= 1.5
				Music.playsoundfire()
				var tween = create_tween()
				for u in ugn.get_children():
					tween.tween_property(u, "scale",Vector3(2.0,2.0,2.0), 5)
					tween.set_parallel()
				await tween.finished
				Music.SoundStop()
				ugn.queue_free()
				$vilkas.position.z -=100
				nearchar = false
			elif nearchar2:
				$"../StaticBody3D2".position.x = $vilkas2.position.x - 0.355
				$"../StaticBody3D2".position.y = 3.0
				$"../StaticBody3D2".position.z = $vilkas2.position.z + 3.0
				$"../StaticBody3D2".rotation = Vector3(-0.5,0,0)
				var ugn = ugnis.instantiate()
				get_parent().add_child(ugn)
				ugn.position = map_to_local(local_to_map($vilkas2.position))
				ugn.position.y -= 1.5
				Music.playsoundfire()
				var tween = create_tween()
				for u in ugn.get_children():
					tween.tween_property(u, "scale",Vector3(2.0,2.0,2.0), 5)
					tween.set_parallel()
				await tween.finished
				Music.SoundStop()
				ugn.queue_free()
				$vilkas2.position.z -=100
				nearchar2 = false
			elif nearchar3:
				$"../StaticBody3D2".position.x = $vilkas3.position.x - 0.355
				$"../StaticBody3D2".position.y = 3.0
				$"../StaticBody3D2".position.z = $vilkas3.position.z + 3.0
				$"../StaticBody3D2".rotation = Vector3(-0.5,0,0)
				var ugn = ugnis.instantiate()
				get_parent().add_child(ugn)
				ugn.position = map_to_local(local_to_map($vilkas3.position))
				ugn.position.y -= 1.5
				Music.playsoundfire()
				var tween = create_tween()
				for u in ugn.get_children():
					tween.tween_property(u, "scale",Vector3(2.0,2.0,2.0), 5)
					tween.set_parallel()
				await tween.finished
				Music.SoundStop()
				ugn.queue_free()
				$vilkas3.position.z -=100
				nearchar3 = false
		turn = true
		canmove = true
		skillusage = true
		skillusage2 = true
		$"../CanvasLayer/Panel/EndTurn"["disabled"]= false
		$"../CanvasLayer/Panel/EndTurn"["self_modulate"] = "ffffff"
		$"../CanvasLayer/Panel/VBoxContainer/Skill/Label".text = "⌛0/1"
		$"../CanvasLayer/Panel/VBoxContainer/Skill2/Label".text = "⌛0/1"
		$"../CanvasLayer/Panel/VBoxContainer/Skill"["self_modulate"] = "ffffff"
		if player.mesh.material.albedo_color.a == 0:
			var tween = create_tween()
			tween.tween_property(player.mesh.material, "albedo_color:a", 1, 1)
			await tween.finished
		if nearobj:
			$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff"
		Global.cameramove = true
		turnssurvived +=1
		playermovementPointsx = maxplayermovementPoints
		playermovementPointsz = maxplayermovementPoints


func _on_area_3d_area_entered(area):
	nearobj = true
	if skillusage2:
		$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff"

func _on_area_3d_area_exited(area):
	nearobj = false
	$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff71"
	var tween = create_tween()
	tween.tween_property(player.mesh.material, "albedo_color:a", 1, 1)
	await tween.finished
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


func _on_char_area_3d_area_entered(area):
	nearchar = true


func _on_char_area_3d_area_exited(area):
	nearchar = false


func _on_char_2_area_3d_area_entered(area):
	nearchar2 = true


func _on_char_2_area_3d_area_exited(area):
	nearchar2 = false


func _on_char_3_area_3d_area_entered(area):
	nearchar3 = true


func _on_char_3_area_3d_area_exited(area):
	nearchar3 = false


func _on_win_area_area_entered(area):
	changetocinematic = true
