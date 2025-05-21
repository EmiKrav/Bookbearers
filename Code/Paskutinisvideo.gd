extends CanvasLayer

@onready var menu = preload("res://Bookbearers/Scenes/titrai.tscn")
@onready var textas = "res://Bookbearers/Dialogai/AllGameText.txt"
var checked = true
var scrollcheck = true
var firsts = 0
var ch = true
var tekstas

func _ready():
	if Music.sk != 4:
		Music.play4()
	mainas()
	%Textas.text = "[center]%s[/center]" % tekstas[3][1] 
	%Textas.fit_content=true
	%Textas.visible_characters = -1
	%Textas.visible_ratio = 1
	%Begin.visible =true
	await get_tree().create_timer(0.1).timeout
	#print(%Textas.size.y)
	firsts = %Textas.size.y + %Begin.size.y
	#+ ($Panel/VBoxContainer.size.y/4)
	ch = false
	%Begin.visible =false
	%Textas.fit_content=false
	%Textas.visible_characters = 0
	%Textas.visible_ratio = 0
	$Panel2.visible = false
	%Timer.wait_time = %Textas.text.length()
	%Timer.start()
func _process(delta):
	if $Panel2.visible == true:
		$Panel2.visible = false
	if !ch:
		if %Textas["visible_characters"] != -1:
			%Textas["visible_characters"] = (%Timer.wait_time - %Timer.time_left) * 20
		if %Textas["visible_characters"] > 100  and %Textas.size.y < firsts  and %Begin.visible == false:
			%Textas.position.y -= delta * 60
			%Textas.size.y += delta * 60
		if %Begin.visible and scrollcheck:
			%Textas.scroll_active = true
			%Textas.get_v_scroll_bar().visible = false
			%Textas.scroll_to_line(%Textas.get_line_count())
			scroll()
		if %Textas.visible_ratio == 1.0:
			button()
	if Input.is_action_just_pressed("Skip"):
		get_tree().change_scene_to_packed(menu)

func button():
	await get_tree().create_timer(2).timeout
	if checked:
		%Begin.visible = true
		#%Begin.disabled = false
		checked = false
func scroll():
	scrollcheck = false

func _on_begin_pressed():
	get_tree().change_scene_to_packed(menu)
	
func mainas():    
	var number = []
	var file = FileAccess.open(textas, FileAccess.READ)
	var content = file.get_as_text()
	var actual_string = content.format({"insertname": Global.childName})
	tekstas = str_to_var(actual_string)
