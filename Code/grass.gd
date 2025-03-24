extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$"."["emitting"]=true;
	await get_tree().create_timer(1.0).timeout
	$"."["speed_scale"]=0;
	process_mode = PROCESS_MODE_DISABLED
	
	
