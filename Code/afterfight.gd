extends Node2D

@onready var zemelapis = load("res://Bookbearers/Scenes/zemelapis.tscn")

var kalbeti = false
var dialogas
var eilute = 0
var questnr = 0
var goback = false
@onready var childhead = preload("res://Bookbearers/Textures/mousechild.png")
var pokalbis = [[0,0,"I need to avaoid these fights"],
[0,0,"I need to avaoid these fights"]]
@onready var menu = preload("res://Bookbearers/Scenes/menuback.tscn")
var paused = false
func _ready():
	Music.SoundStop()
	await get_tree().create_timer(3).timeout
	finished()


func finished():
	if Global.grafspot == 5:
		Global.grafspot = 2
	elif Global.grafspot == 22:
		Global.grafspot = 19
	elif Global.grafspot == 24:
		Global.grafspot = 23
	elif Global.grafspot == 37:
		Global.grafspot = 36
	elif Global.grafspot == 47:
		Global.grafspot = 46
	elif Global.grafspot == 60:
		Global.grafspot = 59
	get_tree().change_scene_to_packed(zemelapis)
