extends Camera3D

@export var speed = 10
@export var rotationspeed = 0.25
@export var upriba = 10
@export var dpriba = 1
@export var lriba = -5
@export var rriba = 5
@export var friba = -5
@export var briba = 5
@export var rdriba = -0.5
@export var ruriba = -1.5

func _process(delta):

	if Input.is_action_pressed("left"):
		if position.x - speed * delta > lriba:
			position.x -= speed * delta
		else:
			position.x = lriba 
	if Input.is_action_pressed("right"):
		if position.x + speed * delta < rriba:
			position.x += speed * delta
		else:
			position.x = rriba 
	if Input.is_action_pressed("forward"):
		if position.z - speed * delta > friba:
			position.z -= speed * delta
		else:
			position.z = friba 
	if Input.is_action_pressed("backward"):
		if position.z + speed * delta < briba:
			position.z += speed * delta
		else:
			position.z = briba 
	if Input.is_action_pressed("up") :
		if position.y + speed * delta < upriba:
			position.y += speed * delta
		else:
			position.y = upriba 
	if Input.is_action_pressed("down"):
		if position.y - speed * delta > dpriba:
			position.y -= speed * delta
		else:
			position.y = dpriba
		
	if Input.is_action_pressed("rotate_down"):
		if rotation.x + rotationspeed * delta < rdriba:
			rotation.x += rotationspeed * delta
		else:
			rotation.x = rdriba 
	if Input.is_action_pressed("rotate_up"):
		if rotation.x - rotationspeed * delta > ruriba:
			rotation.x -= rotationspeed * delta
		else:
			rotation.x = ruriba 
	if Input.is_action_pressed("rotate_left"):
		rotation.y += rotationspeed * delta
	if Input.is_action_pressed("rotate_right"):
		rotation.y -= rotationspeed * delta

