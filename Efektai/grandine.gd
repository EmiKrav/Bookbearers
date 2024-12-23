extends Node3D
@onready var grandmat = load("res://Bookbearers/Efektai/grandine.material")
	

func zaib():
	await get_tree().create_timer(20).timeout
	$".".queue_free()
	
func _ready():
	zaib();
	
	grandmat.set_shader_parameter("sk", Time.get_ticks_msec()/360.0 + 5.0);
func  _process(delta):
	grandmat.set_shader_parameter("time", Time.get_ticks_msec()/360.0);

