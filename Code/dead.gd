extends Node2D

@onready var zemelapis = preload("res://Bookbearers/Scenes/zemelapis.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/TextureRect/Label.text = str(Global.childName)
	if Global.usedscrolls >= 2:
		$CanvasLayer/TextureButton.visible = true
		$CanvasLayer/TextureButton/Label.visible = true

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
