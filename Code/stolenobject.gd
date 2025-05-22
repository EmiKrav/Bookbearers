extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.posiblequests[0][2] == true and Global.grafspot == 4:
		$CanvasLayer/Panel2/TextureRect.texture = load("res://Bookbearers/Textures/wheat.png")
	if Global.posiblequests[2][2] == true and Global.grafspot == 14:
		$CanvasLayer/Panel2/TextureRect.texture = load("res://Bookbearers/Textures/goodflour.png")
	if Global.posiblequests[4][2] == true and Global.grafspot == 4:
		$CanvasLayer/Panel2/TextureRect.texture =load("res://Bookbearers/Textures/bread(1).png")
	if Global.posiblequests[6][2] == true and Global.grafspot == 31:
		$CanvasLayer/Panel2/TextureRect.texture = load("res://Bookbearers/Textures/potion(1).png")
	if Global.posiblequests[8][2] == true and Global.grafspot == 55:
		$CanvasLayer/Panel2/TextureRect.texture = load("res://Bookbearers/Textures/flowers(1).png")
	
	await get_tree().create_timer(3).timeout
	queue_free()


