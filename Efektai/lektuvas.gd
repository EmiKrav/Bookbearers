extends MeshInstance3D
func naikinti():
	await get_tree().create_timer(20).timeout
	$".".queue_free()
	
func _ready():
	naikinti();
	var lektuvomat = load("res://Bookbearers/Efektai/lektuvas.material")
	self.material_override = lektuvomat;
	self.material_override.set_shader_parameter("sk", Time.get_ticks_msec()/360.0 + 5.0);
func  _process(delta):
	self.material_override.set_shader_parameter("time", Time.get_ticks_msec()/360.0);
