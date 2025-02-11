extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var kalbeti = false
var dialogas
var eilute = 0

var goback = false
@onready var firstfight = preload("res://Bookbearers/Scenes/firstfight.tscn")
@onready var childhead = preload("res://Bookbearers/Textures/mousechildhead.png")
@onready var head = preload("res://Bookbearers/Textures/enemyhead.png")

@onready var zemelapis = load("res://Bookbearers/Scenes/zemelapis.tscn")
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func get_input():
	var input_direction = Input.get_vector("left2d", "right2d", "up2d", "down2d")
	velocity = input_direction * SPEED

func _physics_process(delta):
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if kalbeti:
		$"../CanvasLayer".visible = true
		if dialogas[eilute][1] == 0:
			$"../CanvasLayer/Panel/VBoxContainer/HBoxContainer/TextureRect".texture = childhead
		else:
			$"../CanvasLayer/Panel/VBoxContainer/HBoxContainer/TextureRect".texture = head
				
		$"../CanvasLayer/Panel/VBoxContainer/HBoxContainer/RichTextLabel".text = dialogas[eilute][2]
		$"../CanvasLayer/Panel/TextureRect".size = $"../CanvasLayer/Panel/VBoxContainer/HBoxContainer".size
		$"../CanvasLayer/Panel/TextureRect".global_position = $"../CanvasLayer/Panel/VBoxContainer/HBoxContainer".global_position
		if Input.is_action_just_pressed("ui_accept"):
			eilute +=1
			if eilute< dialogas.size():
				if dialogas[eilute][1] == 0:
					$"../CanvasLayer/Panel/VBoxContainer/HBoxContainer/TextureRect".texture = childhead
				else:
					$"../CanvasLayer/Panel/VBoxContainer/HBoxContainer/TextureRect".texture = head
				
				$"../CanvasLayer/Panel/VBoxContainer/HBoxContainer/RichTextLabel".text = dialogas[eilute][2]
				$"../CanvasLayer/Panel/TextureRect".size = $"../CanvasLayer/Panel/VBoxContainer/HBoxContainer".size
				$"../CanvasLayer/Panel/TextureRect".global_position = $"../CanvasLayer/Panel/VBoxContainer/HBoxContainer".global_position
		
			else:
				kalbeti = false
				$"../CanvasLayer".visible = false
				eilute = 0
				if Global.quests != null:
					if Global.posiblequests[0][2] == false:
						Global.quests += Global.posiblequests[0][1]
				else:
					Global.quests = Global.posiblequests[0][1]
					Global.posiblequests[0][2] = true
				
	else:
		get_input()
		move_and_slide()
	if goback:
		get_tree().change_scene_to_packed(zemelapis)


func _on_area_2d_body_entered(body):
	mainas()
	kalbeti = true
	
func mainas():    
	var number = []
	var file = FileAccess.open("res://Bookbearers/Dialogai/dialogassuvilku.txt", FileAccess.READ)
	var content = file.get_as_text()
	dialogas = str_to_var(content)



func _on_area_2d_2_body_entered(body):
	goback = true
