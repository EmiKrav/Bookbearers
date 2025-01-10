extends TextureRect

func _ready():
	self.material.set_shader_parameter("sk", Time.get_ticks_msec()/360.0+1.0);
func  _process(delta):
	self.material.set_shader_parameter("time", Time.get_ticks_msec()/360.0);
