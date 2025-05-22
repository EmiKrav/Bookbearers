extends Node2D


var kalbeti = false
var dialogas
var eilute = 0
var questnr = 6
var goback = false
@onready var firstfight = preload("res://Bookbearers/Scenes/firstfight.tscn")
@onready var childhead = preload("res://Bookbearers/Textures/mousechild.png")
@onready var head = preload("res://Bookbearers/Textures/egle.png")

@onready var zemelapis = load("res://Bookbearers/Scenes/zemelapis.tscn")
var pirmaspokalbis = "res://Bookbearers/Dialogai/dialogassuegle.txt"
var paskutinispokalbis = "res://Bookbearers/Dialogai/paskutinisdialogassuegle.txt"
var pokalbis

@onready var menu = preload("res://Bookbearers/Scenes/menuback.tscn")
var paused = false
func _ready():
	Music.SoundStop()
	if  Global.posiblequests[6][3] == false:
		pokalbis = pirmaspokalbis
		Global.posiblequests[6][2] = true
	else:
		Global.posiblequests[7][3] = true
		Global.posiblequests[7][2] = false
		Global.posiblequests[6][2] = false
		pokalbis = paskutinispokalbis
		
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

