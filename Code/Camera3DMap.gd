extends CharacterBody3D

@export var speed = 10
@export var rotationspeed = 0.5

@export var upriba = 2.6
@export var dpriba = 0

@export var rdriba = 1.0
@export var ruriba = -1.5


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
			if global_position.y + speed * delta < upriba:
				global_position.y += speed * delta
			else:
				global_position.y = upriba 
		if Input.is_action_pressed("down"):
			if global_position.y - speed * delta > dpriba:
				global_position.y -= speed * delta
			else:
				global_position.y = dpriba
			
		if Input.is_action_pressed("rotate_down"):
			if global_rotation.x + rotationspeed * delta < rdriba:
				global_rotation.x += rotationspeed * delta
			else:
				global_rotation.x = rdriba 
		if Input.is_action_pressed("rotate_up"):
			if global_rotation.x - rotationspeed * delta > ruriba:
				global_rotation.x -= rotationspeed * delta
			else:
				global_rotation.x = ruriba 
		if Input.is_action_pressed("rotate_left"):
			global_rotation.y += rotationspeed * delta
			
		if Input.is_action_pressed("rotate_right"):
			global_rotation.y -= rotationspeed * delta
			
			
		
		move_and_slide()


