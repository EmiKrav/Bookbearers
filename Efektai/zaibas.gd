extends Node3D

var number = 0;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Letters.emitting = true;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_letters_finished():
	await get_tree().create_timer(1).timeout
	$Ligthning.emitting = true;
	$Letters.queue_free()


func _on_ligthning_finished():
	zaib()
	
func zaib():
	number+=1;
	await get_tree().create_timer(0.5).timeout
	$Ligthning.emitting = true;
	if number > 5:
		$".".queue_free()
