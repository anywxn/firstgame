extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
var doublejump = true
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DJUMP = -200.0
var Health = 100
var Rings = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("attack") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Fastrun")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
	
	if direction == 1:
		$AnimatedSprite2D.flip_h = true
	elif direction == -1:
		$AnimatedSprite2D.flip_h = false
		
	if velocity.y > 1:
		anim.play("Jump")
	
	if Health <= 0:
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")

	move_and_slide()
