extends CharacterBody3D

@export var speed = 10
@export var rotationspeed = 0.5

@export var upriba = 25
@export var dpriba = 2

@export var rdriba = 0.5
@export var ruriba = -1.5
@onready var mat = preload("res://Bookbearers/Efektai/post1.material")

func _process(delta):
	if Global.cameramove:	
		var left = transform.basis.z.normalized() * speed
		var backward = transform.basis.x.normalized() * speed
		
		
		if Input.is_action_pressed("left"):
			transform.origin += left.cross(Vector3.UP) / 35
		if Input.is_action_pressed("right"):
			transform.origin -= left.cross(Vector3.UP) / 35
		if Input.is_action_pressed("forward"):
			transform.origin -= backward.cross(Vector3.UP) / 35
		if Input.is_action_pressed("backward"):
			transform.origin += backward.cross(Vector3.UP) / 35
			
			
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
		move_and_slide()


