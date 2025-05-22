extends Node2D


var kalbeti = false
var dialogas
var eilute = 0
var questnr = 0
var goback = false
@onready var firstfight = preload("res://Bookbearers/Scenes/firstfight.tscn")
@onready var childhead = preload("res://Bookbearers/Textures/mousechild.png")
@onready var head = preload("res://Bookbearers/Textures/vilkas.png")

@onready var zemelapis = load("res://Bookbearers/Scenes/zemelapis.tscn")
var pirmaspokalbis = "res://Bookbearers/Dialogai/dialogassuvilku.txt"
var paskutinispokalbis = "res://Bookbearers/Dialogai/paskutinisdialogassuvilku.txt"
var antraspokalbis = "res://Bookbearers/Dialogai/antrasdialogassuvilku.txt"
var treciaspokalbis = "res://Bookbearers/Dialogai/treciasdialogassuvilku.txt"

var pokalbis
@onready var menu = preload("res://Bookbearers/Scenes/menuback.tscn")
var paused = false
func _ready():
	Music.SoundStop()
	if 	Global.posiblequests[5][2] == true:
		 #or Global.posiblequests[4][3] == true or Global.posiblequests[5][3] == true:
		pokalbis = paskutinispokalbis
		Global.posiblequests[5][3] = true
		Global.posiblequests[5][2] = false
	if 	Global.posiblequests[3][2] == true:
		 #or Global.posiblequests[2][3] == true or Global.posiblequests[3][3] == true:
		pokalbis = treciaspokalbis
		Global.posiblequests[3][3] = true
		Global.posiblequests[3][2] = false
		Global.posiblequests[4][2] = true
	if 	Global.posiblequests[1][2] == true:
		 #or Global.posiblequests[0][3] == true or Global.posiblequests[1][3] == true:
		pokalbis = antraspokalbis
		Global.posiblequests[1][3] = true
		Global.posiblequests[1][2] = false
		Global.posiblequests[2][2] = true
	if 	Global.posiblequests[0][3] == false:
		pokalbis = pirmaspokalbis
		Global.posiblequests[0][2] = true
	mainas()
	kalbeti = true
func _physics_process(delta):
	if kalbeti:
		if dialogas[eilute][1] == 0:
			$"CanvasLayer/Panel/TextureRect2".texture = childhead
		else:
			$"CanvasLayer/Panel/TextureRect2".texture = head
				
		$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/RichTextLabel".text = dialogas[eilute][2]
		$"CanvasLayer/Panel/TextureRect".size = $"CanvasLayer/Panel/VBoxContainer/HBoxContainer".size
		$"CanvasLayer/Panel/TextureRect".global_position = $"CanvasLayer/Panel/VBoxContainer/HBoxContainer".global_position
		if Input.is_action_just_pressed("skip"):
			eilute +=1
			if eilute< dialogas.size():
				if dialogas[eilute][1] == 0:
					$"CanvasLayer/Panel/TextureRect2".texture = childhead
				else:
					$"CanvasLayer/Panel/TextureRect2".texture = head
				
				$"CanvasLayer/Panel/VBoxContainer/HBoxContainer/RichTextLabel".text = dialogas[eilute][2]
				$"CanvasLayer/Panel/TextureRect".size = $"CanvasLayer/Panel/VBoxContainer/HBoxContainer".size
				$"CanvasLayer/Panel/TextureRect".global_position = $"CanvasLayer/Panel/VBoxContainer/HBoxContainer".global_position
		
			else:
				kalbeti = false
				eilute = 0
				goback = true
	if goback:
		Global.day+=1;
		get_tree().change_scene_to_packed(zemelapis)


func mainas():    
	var number = []
	var file = FileAccess.open(pokalbis, FileAccess.READ)
	var content = file.get_as_text()
	dialogas = str_to_var(content)

func _input(event):
	if Input.is_action_pressed("Esc"):
		if !paused:
			var w = menu.instantiate()
			$".".add_child(w)
			paused = true
			get_tree().paused = true;
		else:
			get_tree().paused = false;
			paused = false
