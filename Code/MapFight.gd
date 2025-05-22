extends GridMap

@onready var langelis = preload("res://Bookbearers/Scenes/ejimolangelis.tscn")
@onready var langeliomat = preload("res://Bookbearers/Materials/langelis.tres")
@onready var langelimiromat = preload("res://Bookbearers/Materials/mirtieskuno.tres")
@onready var zemelapis = preload("res://Bookbearers/Scenes/zemelapis.tscn")
@onready var mirtis = preload("res://Bookbearers/Scenes/dead.tscn")
@onready var enemyhead = preload("res://Bookbearers/Textures/enemyhead.png")
@onready var playeryhead = preload("res://Bookbearers/Textures/mousebookbringerfightmodehead.png")
@onready var tree =  preload("res://Bookbearers/Scenes/kelmas.tscn")

@onready var skill1cin = preload("res://Bookbearers/Cinematic/skill1.tscn")
@onready var skill2cin = preload("res://Bookbearers/Cinematic/skill2.tscn")
@onready var enemyattackanim = preload("res://Bookbearers/Cinematic/zandarasvsknyg.tscn")


@onready var menu = preload("res://Bookbearers/Scenes/menuback.tscn")
var paused = false

@export var maxplayermovementPoints = 4
var playermovementPointsx = maxplayermovementPoints
var playermovementPointsz = maxplayermovementPoints
@export var playerattackrange = 3
var playerhealth = Global.health
@export var enemymovementPoints = 3
@export var enemyattackrange = 2
@export var enemymaxhealth = 2
@export var skill2coldown = 3
@export var skill3coldown = 3
@export var skilldmg = 2
@export var skill2dmg = 1
@export var skill3dmg = 1

var enemieskilled = 0
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
var skill2 = false
var skill3 = false
var skillusage = true
var skillusage2 = true
var skillusage3 = true
var skilling = true
var usingskills = false
var skill2curcoldown = 0
var skill3curcoldown = 0
var skillset = 1;

@onready var player = $player
@onready var enemy = $enemy
@onready var enemy2 = $enemy2
@onready var enemy3 = $enemy3
@onready var enemy4 = $enemy4
@onready var langeliai = $Langeliai


var randomnrz = [-15, -13, -11, -9, -7, -5, -3, -1]
var randomnrx = [15, 13, 11, 9, 7, 5, 3, 1, -1, -3, -5, -7, -9, -11, -13, -15]
var spacepressed = false
func _ready():
	Music.SoundStop()
	if Music.sk != 5:
		Music.play5()
	player.position = Vector3(1,2,15)
	var pos = local_to_map(Vector3(1,1.5,15))
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
	cells = get_used_cells()
	cells.sort()
	var intcount = 0
	var r1 = randi_range(0, 15)
	var r2 = randi_range(0, 15)
	var r3 = randi_range(0, 15)
	for i in cells:
		if intcount < 16:
			if (intcount == r1 || intcount == r2 || intcount == r3) && i != pcurrentpos && i != ecurrentpos && i != ecurrentpos2 && i != ecurrentpos3 && i != ecurrentpos4:	
					$".".set_cell_item(i,-1)
					var med = tree.instantiate()
					$"../Node3D2".add_child(med)
					med.position = map_to_local(i)
		else:
			intcount = 0
			r1 = randi_range(0, 15)
			r2 = randi_range(0, 15)
			r3 = randi_range(0, 15)
			if (intcount == r1 || intcount == r2 || intcount == r3) && i != pcurrentpos && i != ecurrentpos && i != ecurrentpos2 && i != ecurrentpos3 && i != ecurrentpos4:	
					$".".set_cell_item(i,-1)
					var med = tree.instantiate()
					$"../Node3D2".add_child(med)
					med.position = map_to_local(i)
		intcount +=1;
	cells = get_used_cells()
	othenemypos.clear()
	othenemypos.append(ecurrentpos)
	othenemypos.append(ecurrentpos2)
	othenemypos.append(ecurrentpos3)
	othenemypos.append(ecurrentpos4)
	enemy.get_child(1).text = str(enemymaxhealth)
	enemy2.get_child(1).text =  str(enemymaxhealth)
	enemy3.get_child(1).text =  str(enemymaxhealth)
	enemy4.get_child(1).text =  str(enemymaxhealth)
	$"../CanvasLayer/Panel/VBoxContainer/TextureButton2/Label".text = "⌛"+ str(skill2curcoldown) + "/" + str(skill2coldown)
	$"../CanvasLayer/Panel/VBoxContainer/TextureButton3/Label".text = "⌛"+ str(skill3curcoldown) + "/" + str(skill3coldown)
	
func _input(event):
	if Input.is_action_pressed("Esc"):
		if !paused:
			var w = menu.instantiate()
			get_parent().add_child(w)
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
		
func playermove(langelistomove):
	$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - int(playerhealth)
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"

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
	tween.tween_property(player, "position", Vector3(pos.x, 2, player.position.z), 1)
	await tween.finished
	var tween2 = create_tween()
	tween2.tween_property(player, "position", Vector3(player.position.x, 2, pos.z), 1)
	await tween2.finished
	Music.SoundStop()
	$player/Camera3D2.current = false
	$"../StaticBody3D2".position.x = player.position.x - 0.355
	$"../StaticBody3D2".position.y = 5.0
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
	if playerhealth <= 0:
		if player != null:
			player.queue_free()
		get_tree().change_scene_to_packed(mirtis)
	if Global.animationplaying:
		$"../CanvasLayer".visible = false
	if !Global.animationplaying:
		$"../CanvasLayer".visible = true
	if enemieskilled == 4 or Global.autopereiti:
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
	
	if skill == true and skillusage and skilling and !usingskills:
		useskill1()
	if skill2 == true and skillusage2 and skilling and !usingskills and skill2curcoldown == 0:
		useskill2()
	if skill3 == true and skillusage3 and skilling and !usingskills and skill3curcoldown == 0:
		useskill3()
		
func enemyhurt(langelistomove, dmg):
	await get_tree().create_timer(1).timeout
	if enemy != null && langelistomove[0] == ecurrentpos.x && langelistomove[1] == ecurrentpos.y && langelistomove[2] == ecurrentpos.z:
		if dmg == 2:
			var anim1 = skill1cin.instantiate()
			$"..".add_child(anim1)
		else:
			var anim2 = skill2cin.instantiate()
			$"..".add_child(anim2)
		await get_tree().create_timer(1).timeout
		var gyv = enemy.get_child(1).text
		enemy.get_child(1).text = str(str_to_var(gyv) - dmg) 
		if str_to_var(enemy.get_child(1).text) <= 0:
			enemy.queue_free()
			var pos2 = map_to_local(ecurrentpos)
			pos2 += Vector3(0,0.1,0)
			var lang = langelis.instantiate()
			$".".add_child(lang)
			lang.position = pos2
			lang["material_override"] = langelimiromat
			enemieskilled +=1
	elif enemy2 != null && langelistomove[0] == ecurrentpos2.x && langelistomove[1] == ecurrentpos2.y && langelistomove[2] == ecurrentpos2.z:
		if dmg == 2:
			var anim1 = skill1cin.instantiate()
			$"..".add_child(anim1)
		else:
			var anim2 = skill2cin.instantiate()
			$"..".add_child(anim2)
		await get_tree().create_timer(1).timeout
		var gyv = enemy2.get_child(1).text
		enemy2.get_child(1).text = str(str_to_var(gyv) - dmg) 
		if str_to_var(enemy2.get_child(1).text) <= 0:
			enemy2.queue_free()
			var pos2 = map_to_local(ecurrentpos2)
			pos2 += Vector3(0,0.1,0)
			var lang = langelis.instantiate()
			$".".add_child(lang)
			lang.position = pos2
			lang["material_override"] = langelimiromat
			enemieskilled +=1
	elif enemy3 != null && langelistomove[0] == ecurrentpos3.x && langelistomove[1] == ecurrentpos3.y && langelistomove[2] == ecurrentpos3.z:
		if dmg == 2:
			var anim1 = skill1cin.instantiate()
			$"..".add_child(anim1)
		else:
			var anim2 = skill2cin.instantiate()
			$"..".add_child(anim2)
		await get_tree().create_timer(1).timeout
		var gyv = enemy3.get_child(1).text
		enemy3.get_child(1).text = str(str_to_var(gyv) - dmg) 
		if str_to_var(enemy3.get_child(1).text) <= 0:
			enemy3.queue_free()
			var pos2 = map_to_local(ecurrentpos3)
			pos2 += Vector3(0,0.1,0)
			var lang = langelis.instantiate()
			$".".add_child(lang)
			lang.position = pos2
			lang["material_override"] = langelimiromat
			enemieskilled +=1
	elif enemy4 != null && langelistomove[0] == ecurrentpos4.x && langelistomove[1] == ecurrentpos4.y && langelistomove[2] == ecurrentpos4.z:
		if dmg == 2:
			var anim1 = skill1cin.instantiate()
			$"..".add_child(anim1)
		else:
			var anim2 = skill2cin.instantiate()
			$"..".add_child(anim2)
		await get_tree().create_timer(1).timeout
		var gyv = enemy4.get_child(1).text
		enemy4.get_child(1).text = str(str_to_var(gyv) - dmg) 
		if str_to_var(enemy4.get_child(1).text) <= 0:
			enemy4.queue_free()
			var pos2 = map_to_local(ecurrentpos4)
			pos2 += Vector3(0,0.1,0)
			var lang = langelis.instantiate()
			$".".add_child(lang)
			lang.position = pos2
			lang["material_override"] = langelimiromat
			enemieskilled +=1
	
	
	$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - int(playerhealth)
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
	
func animacijalang():
	var tween = create_tween()
	tween.tween_property(langeliai.get_child(0), "material_override:albedo_color:a", 0, 1)
	if langeliai.get_child_count() > 1:
		tween.tween_property(langeliai.get_child(1), "material_override:albedo_color:a", 0, 1)
	if langeliai.get_child_count() > 2:
		tween.tween_property(langeliai.get_child(2), "material_override:albedo_color:a", 0, 1)
	if langeliai.get_child_count() > 3:
		tween.tween_property(langeliai.get_child(3), "material_override:albedo_color:a", 0, 1)
			#tween.tween_property(langeliomat, "albedo_color:a", 0, 3)
	await tween.finished
		
func useskill2():
	usingskills = true
	var langelistomove = shoot_ray()
	var ppos = pcurrentpos
	var at1 : Array
	if langelistomove != null :
		var atstumasx = ppos.x -langelistomove.x
		var atstumasz = ppos.z -langelistomove.z
		if abs(atstumasx) <= playerattackrange and abs(atstumasz) <= playerattackrange:
			if cells.has(langelistomove):
				var pos = map_to_local(langelistomove)
				pos += Vector3(0,0.1,0)
				var lang = langelis.instantiate()
				langeliai.add_child(lang)
				lang.position = pos
			if cells.has(langelistomove+ Vector3i(1,0,0)):
				var lang2 = langelis.instantiate()
				langeliai.add_child(lang2)
				var pos = map_to_local(langelistomove + Vector3i(1,0,0))
				pos += Vector3(0,0.1,0)
				lang2.position = pos
			if cells.has(langelistomove+ Vector3i(-1,0,0)):
				var lang3 = langelis.instantiate()
				langeliai.add_child(lang3)
				var pos = map_to_local(langelistomove + Vector3i(-1,0,0))
				pos += Vector3(0,0.1,0)
				lang3.position = pos
			for i in range(0, langeliai.get_child_count()-3):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
	else:
		for i in range(0, langeliai.get_child_count()):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
	if langelistomove != null && Input.is_action_just_pressed("Click") && cells.has(langelistomove) and langeliai.get_child_count()>=1:
		skill2 = false
		skillusage2 = false
		skill2curcoldown = skill2coldown
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffff71"
		
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton2/Label".text = "⌛"+ str(skill2curcoldown) + "/" + str(skill2coldown)
		await animacijalang()
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				at1.append(local_to_map(langeliai.get_child(i).position))
				langeliai.get_child(i).queue_free()
		for i in range(0,at1.size()):
			enemyhurt(at1[i], skill2dmg)
	usingskills = false
	
func useskill3():
	usingskills = true
	var langelistomove = shoot_ray()
	var ppos = pcurrentpos
	var at1 : Array
	if langelistomove != null :
		var atstumasx = ppos.x -langelistomove.x
		var atstumasz = ppos.z -langelistomove.z
		if abs(atstumasx) <= playerattackrange and abs(atstumasz) <= playerattackrange:
			if cells.has(langelistomove):
				var pos = map_to_local(langelistomove)
				pos += Vector3(0,0.1,0)
				var lang = langelis.instantiate()
				langeliai.add_child(lang)
				lang.position = pos
			if cells.has(langelistomove+ Vector3i(0,0,1)):
				var lang2 = langelis.instantiate()
				langeliai.add_child(lang2)
				var pos = map_to_local(langelistomove + Vector3i(0,0,1))
				pos += Vector3(0,0.1,0)
				lang2.position = pos
			if cells.has(langelistomove+ Vector3i(0,0,-1)):
				var lang3 = langelis.instantiate()
				langeliai.add_child(lang3)
				var pos = map_to_local(langelistomove + Vector3i(0,0,-1))
				pos += Vector3(0,0.1,0)
				lang3.position = pos
			for i in range(0, langeliai.get_child_count()-3):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
	else:
		for i in range(0, langeliai.get_child_count()):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
	if langelistomove != null && Input.is_action_just_pressed("Click") && cells.has(langelistomove) and langeliai.get_child_count()>=1:
		skill3 = false
		skillusage3 = false
		skill3curcoldown = skill3coldown
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffff71"
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton3/Label".text = "⌛"+ str(skill3curcoldown) + "/" + str(skill3coldown)
		await animacijalang()
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				at1.append(local_to_map(langeliai.get_child(i).position))
				langeliai.get_child(i).queue_free()
		for i in range(0,at1.size()):
			enemyhurt(at1[i], skill3dmg)
	usingskills = false
	
func useskill1():
	usingskills = true
	var langelistomove = shoot_ray()
	var ppos = pcurrentpos
	var at1 : Array
	if langelistomove != null :
		var atstumasx = ppos.x -langelistomove.x
		var atstumasz = ppos.z -langelistomove.z
		if abs(atstumasx) <= playerattackrange and abs(atstumasz) <= playerattackrange:
			var pos = map_to_local(langelistomove)
			pos += Vector3(0,0.1,0)
			var lang = langelis.instantiate()
			langeliai.add_child(lang)
			lang.position = pos
			for i in range(0, langeliai.get_child_count()-1):
					if langeliai.get_child(i) != null:
						langeliai.get_child(i).queue_free()
	else:
		for i in range(0, langeliai.get_child_count()):
				if langeliai.get_child(i) != null:
					langeliai.get_child(i).queue_free()
	#print(langelistomove)
	if langelistomove != null && Input.is_action_just_pressed("Click") && cells.has(langelistomove) and langeliai.get_child_count()>=1:
		skill = false
		skillusage = false
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffff71"
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton/Label".text = "⌛1/1"
		await animacijalang()
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				at1.append(local_to_map(langeliai.get_child(i).position))
				langeliai.get_child(i).queue_free()
		for i in range(0,at1.size()):
			enemyhurt(at1[i], skilldmg)
	usingskills = false
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
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - int(playerhealth)
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
	if turn && canmove && !usingskills:
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
	$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = enemyhead
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = enemymaxhealth
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = enemymaxhealth - int(enemyi.get_child(1).text)
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = enemyi.get_child(1).text + "/" + str(enemymaxhealth)
			
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
	$"../CanvasLayer".visible = false
	$"../StaticBody3D2/Camera3D".current = false
	$player/Camera3D2.current = true
	var anim1 = enemyattackanim.instantiate()
	$"..".add_child(anim1)
	await get_tree().create_timer(1).timeout
	playerhealth = playerhealth-2
	Global.health -= 2 
	$"../CanvasLayer".visible = true
	$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - playerhealth
	$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
	if player != null:
		$player/Camera3D2.current = false
	$"../StaticBody3D2/Camera3D".current = true
			
func showMovement(playermovementPointsx, playermovementPointsz):
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
	#if movemcellls.has(ecurrentpos2):
	movemcellls.erase(ecurrentpos2)
	#if movemcellls.has(ecurrentpos3):
	movemcellls.erase(ecurrentpos3)
	#if movemcellls.has(ecurrentpos4):
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

func _on_texture_rect_pressed():
	if !moving  and !spacepressed:
		Global.cameramove = false
		skillusage = false
		skill = false
		skillusage2 = false
		skill2 = false
		skillusage3 = false
		skill3 = false
		skilling = false
		if skill2curcoldown > 0:
			skill2curcoldown = skill2curcoldown - 1;
		
		if skill3curcoldown > 0:
			skill3curcoldown = skill3curcoldown - 1;
		$"../CanvasLayer/Panel/TextureRect"["self_modulate"] = "ffffff71"
		$"../CanvasLayer/Panel/TextureRect"["disabled"]= true
		turn = false
		if enemy != null:
			ecurrentpos = await enemyMove(ecurrentpos, enemy)
			if abs(pcurrentpos.x - ecurrentpos.x) <= enemyattackrange and  abs(pcurrentpos.z -ecurrentpos.z) <= enemyattackrange:
				await enemyAttack(enemy)
		if enemy2 != null:
			ecurrentpos2 = await enemyMove(ecurrentpos2, enemy2)
			if abs(pcurrentpos.x -ecurrentpos2.x) <= enemyattackrange and abs(pcurrentpos.z -ecurrentpos2.z) <= enemyattackrange:
				await enemyAttack(enemy2)
		if enemy3 != null:
			ecurrentpos3 = await enemyMove(ecurrentpos3, enemy3)
			if abs(pcurrentpos.x -ecurrentpos3.x) <= enemyattackrange and abs(pcurrentpos.z -ecurrentpos3.z) <= enemyattackrange:
				await enemyAttack(enemy3)
		if enemy4 != null:
			ecurrentpos4 = await enemyMove(ecurrentpos4, enemy4)
			if abs(pcurrentpos.x -ecurrentpos4.x )<= enemyattackrange and abs(pcurrentpos.z -ecurrentpos4.z) <= enemyattackrange:
				await enemyAttack(enemy4)
		$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - playerhealth
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
	
		turn = true
		canmove = true
		skillusage = true
		skillusage2 = true
		skillusage3 = true
		usingskills = false
		skilling = true
		$"../CanvasLayer/Panel/TextureRect"["disabled"]= false
		$"../CanvasLayer/Panel/TextureRect"["self_modulate"] = "ffffff"
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffff"
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton/Label".text = "⌛0/1"
		if skill2curcoldown == 0:
			$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffff"
		if skill3curcoldown == 0:
			$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffff"
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton2/Label".text = "⌛"+ str(skill2curcoldown) + "/" + str(skill2coldown)
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton3/Label".text = "⌛"+ str(skill3curcoldown) + "/" + str(skill3coldown)
		Global.cameramove = true
		playermovementPointsx = maxplayermovementPoints
		playermovementPointsz = maxplayermovementPoints
		
func _on_texture_button_pressed():
	if !spacepressed:
		$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - int(playerhealth)
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
		selected = false
		redraw = true
		if skillusage and !usingskills:
			skill2 = false
			skill3 = false
			langeliomat.albedo_color.a = 1
			if skill == false:
				$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffffbd"
				if skillusage2 and skill2curcoldown == 0:
					$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffffff"
				if skillusage3 and skill3curcoldown == 0:
					$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffffff"
				skill=true
			elif skill == true:
				$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffffff"
				skill = false

func _on_texture_button_mouse_entered():
	skilling = false
	selected = false
	if skillusage == true and skill:
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()


func _on_texture_button_mouse_exited():
	skilling = true


func _on_texture_button_2_pressed():
	if !spacepressed:
		$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - int(playerhealth)
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
		selected = false
		redraw = true
		if skillusage2 and !usingskills:
			skill = false
			skill3 = false
			langeliomat.albedo_color.a = 1
			if skill2 == false and skill2curcoldown == 0:
				$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffffbd"
				if skillusage:
					$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffffff"
				if skillusage3 and skill3curcoldown == 0:
					$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffffff"
				
				skill2=true
			elif skill2 == true:
				$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffffff"
				skill2 = false

func _on_texture_button_2_mouse_entered():
	skilling = false
	selected = false
	if skillusage2 == true and skill2:
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()


func _on_texture_button_2_mouse_exited():
	skilling = true


func _on_texture_button_3_pressed():
	if !spacepressed:
		$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = playeryhead
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = 10
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = 10 - int(playerhealth)
		$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = str(playerhealth) + "/10"
		selected = false
		redraw = true
		if skillusage3 and !usingskills:
			skill = false
			skill2 = false
			langeliomat.albedo_color.a = 1
			if skill3 == false and skill3curcoldown == 0:
				$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffffbd"
				if skillusage2 and skill2curcoldown == 0:
					$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffffff"
				if skillusage:
					$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffffff"
				
				skill3=true
			elif skill3 == true:
				$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffffff"
				skill3 = false

func _on_texture_button_3_mouse_entered():
	skilling = false
	selected = false
	if skillusage3 == true and skill3:
		for i in range(0, langeliai.get_child_count()):
			if langeliai.get_child(i) != null:
				langeliai.get_child(i).queue_free()


func _on_texture_button_3_mouse_exited():
	skilling = true


func _on_texture_button_4_pressed():
	if skillset == 1:
		skillset = 2;
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton4/Label".text=str(skillset)
		return
	if skillset == 2:
		skillset = 3;
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton4/Label".text=str(skillset)
		return
	if skillset == 3:
		skillset = 1;
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton4/Label".text=str(skillset)
		return


func _on_enemy_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and !usingskills:
			$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = enemyhead
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = enemymaxhealth
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = enemymaxhealth - int(enemy.get_child(1).text)
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = enemy.get_child(1).text + "/" + str(enemymaxhealth)

func _on_enemy_2_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and !usingskills:
			$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = enemyhead
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = enemymaxhealth
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = enemymaxhealth - int(enemy2.get_child(1).text)
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = enemy2.get_child(1).text + "/" + str(enemymaxhealth)
			

func _on_enemy_3_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and !usingskills:
			$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = enemyhead
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = enemymaxhealth
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = enemymaxhealth - int(enemy3.get_child(1).text)
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = enemy3.get_child(1).text + "/" + str(enemymaxhealth)

func _on_enemy_4_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true and !usingskills:
			$"../CanvasLayer/Panel/VBoxContainer2/TextureRect".texture  = enemyhead
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".max_value = enemymaxhealth
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar".value = enemymaxhealth - int(enemy4.get_child(1).text)
			$"../CanvasLayer/Panel/VBoxContainer2/ProgressBar/Label".text = enemy4.get_child(1).text + "/" + str(enemymaxhealth)
			


func _on_texture_rect_mouse_entered():
	selected = false
	redraw = true
	skilling = false
	selected = false
	skill = false
	skill2 = false
	skill3 = false
	if $"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] == Color("ffffffbd"):
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton"["self_modulate"] = "ffffffff"
	if $"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] == Color("ffffffbd"):
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton2"["self_modulate"] = "ffffffff"
	if $"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] == Color("ffffffbd"):
		$"../CanvasLayer/Panel/VBoxContainer/TextureButton3"["self_modulate"] = "ffffffff"
	

