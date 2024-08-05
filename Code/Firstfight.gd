extends GridMap

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")
@onready var zemelapis = preload("res://Bookbearers/Scenes/zemelapis.tscn")
@onready var mirtis = preload("res://Bookbearers/Scenes/dead.tscn")
@onready var langeliomat = preload("res://Bookbearers/Materials/ejimolangelis.tres")

@export var maxplayermovementPoints = 4
var playermovementPointsx = maxplayermovementPoints
var playermovementPointsz = maxplayermovementPoints
@export var playerattackrange = 3
@export var playerhealth = 1
@export var enemymovementPoints = 3
@export var enemyattackrange = 2

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

func _ready():
	player.position = Vector3(1,2,15)
	var pos = local_to_map(Vector3(1,1.5,15))
	pcurrentpos = pos
	enemy.position = Vector3(1,2,-15)
	pos = local_to_map(Vector3(1,2,-15))
	ecurrentpos = pos
	cells = get_used_cells()
	othenemypos.clear()
	othenemypos.append(ecurrentpos)
	$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff71"

func playermove(langelistomove):
	Global.cameramove = false
	$"../StaticBody3D2/Camera3D".current = false
	$player/Camera3D2.current = true
	var pos = map_to_local(langelistomove)
	moving = true
	selected = false
	redraw = true
	var camx = player.position.x - $"../StaticBody3D2".position.x
	var camz = player.position.z - $"../StaticBody3D2".position.z
	$"../StaticBody3D2".position.x = pos.x - camx
	$"../StaticBody3D2".position.z = pos.z - camz
	var prad = pcurrentpos
	var tween = create_tween()
	tween.tween_property(player, "position", Vector3(pos.x, 2, player.position.z), 1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(player, "position", Vector3(player.position.x, 2, pos.z), 1)
	await tween2.finished
	$player/Camera3D2.current = false
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
	if playerhealth <= 0:
		if player != null:
			player.queue_free()
		get_tree().change_scene_to_packed(mirtis)
	if turnssurvived == 6:
		get_tree().paused = true;
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_packed(zemelapis)
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
	if !turn:
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()
		var ppos = pcurrentpos
		var epos = ecurrentposi
		var atstumasx = ppos.x - epos.x
		var atstumasz = ppos.z - epos.z
		var movx = ecurrentposi.x
		var movz = ecurrentposi.z
		var paieskax
		var paieskaz
		othenemypos.clear()
		othenemypos.append(ecurrentpos)
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
	movemcellls.erase(ecurrentpos)
	
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


func _on_skill_2_pressed():
	if !moving and skillusage2 and nearobj:
		skill2 = false
		skillusage2 = false
		invisible = true			
		$"../CanvasLayer/Panel/VBoxContainer/Skill2"["self_modulate"] = "ffffff71"
		var tween = create_tween()
		tween.tween_property(player.mesh.material, "albedo_color:a", 0, 1)
		await tween.finished


func _on_end_turn_pressed():
	if !moving:
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
			if abs(pcurrentpos.x - ecurrentpos.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos.z) <= enemyattackrange:
				await enemyAttack(enemy)
		turn = true
		canmove = true
		skillusage = true
		skillusage2 = true
		$"../CanvasLayer/Panel/EndTurn"["disabled"]= false
		$"../CanvasLayer/Panel/EndTurn"["self_modulate"] = "ffffff"
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

