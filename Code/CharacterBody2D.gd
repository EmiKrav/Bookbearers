extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var firstfight = preload("res://Bookbearers/Scenes/firstfight.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
func get_input():
	var input_direction = Input.get_vector("left2d", "right2d", "up2d", "down2d")
	velocity = input_direction * SPEED

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	get_input()

	move_and_slide()


func _on_area_2d_body_entered(body):
	call_deferred("changelevel")

func changelevel():
	get_tree().change_scene_to_packed(firstfight)
