extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/TextureRect/Label.text = str(Global.childName)
