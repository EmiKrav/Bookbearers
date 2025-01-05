extends Camera3D
var using=false;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ($".".current==true):
		
		using=true;
		#$"../../../postprocessing".global_position =$".".global_position;
		#$"../../../postprocessing".visible=true;
		$"../../../postprocessing2".global_position =$".".global_position;
		$"../../../postprocessing2".visible=true;
	if (using==true and $"../../../StaticBody3D2/Camera3D".current==true):
		#$"../../../postprocessing".visible=false;
		$"../../../postprocessing2".visible=false;
		using=false;
