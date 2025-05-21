extends Node2D

@onready var zemelapis = load("res://Bookbearers/Scenes/zemelapis.tscn")
@onready var menu = load("res://Bookbearers/Scenes/mainmenu.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	if Music.sk != 7:
		Music.play7()
	$CanvasLayer/TextureRect/BoxContainer/Label.text = str(Global.childName)
	if Global.usedscrolls >= 5:
		$CanvasLayer/TextureButton.visible = true
	else:
		$CanvasLayer/TextureButton2.visible = true

func _on_texture_button_pressed():
	Global.health = 10;
	if Global.grafspot == 5:
		Global.grafspot = 2
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 22:
		Global.grafspot = 19
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 24:
		Global.grafspot = 23
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 37:
		Global.grafspot = 36
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 47:
		Global.grafspot = 46
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 60:
		Global.grafspot = 59
		Global.enemy.remove_at(Global.enemy.size()-1)
	elif Global.grafspot == 4:
		Global.grafspot = 3
	elif Global.grafspot == 21:
		Global.grafspot = 19
	elif Global.grafspot == 31:
		Global.grafspot = 30
	elif Global.grafspot == 55:
		Global.grafspot = 54
		
	Global.usedscrolls -=5
	get_tree().change_scene_to_packed(zemelapis)


func _on_texture_button_2_pressed():
	Global.turtorialcomplete = false
	Global.firstchildturtorialcomplete = false
	Global.childName = "?Name?"
	get_tree().change_scene_to_packed(menu)
