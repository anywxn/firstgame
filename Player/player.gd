extends CharacterBody2D

enum{
	MOVE,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	BLOCK,
	SLIDE,
	SONICWIND,
	JUMP,
	DOUBLEJUMP,
}

@onready var anim = $AnimatedSprite2D
@onready var animPlayer = $AnimationPlayer
var doublejump = true
const SPEED = 170.0
const JUMP_VELOCITY = -400.0
const DJUMP = -100.0
var jumps = 0
var MAXJUMPS = 1
var run_speed = 1
var Health = 100
var Rings = 0
var Combo = false
var attack_cooldown = false
var idle_timer = 0
const IDLE_INTERVAL = 1000
var player_pos

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var state = MOVE

func _physics_process(delta):
	match state:
		MOVE:
			move_state()
		ATTACK1:
			attack_state()
		ATTACK2:
			attack2_state()
		ATTACK3:
			attack3_state()
		BLOCK:
			block_state()
		SLIDE:
			slide_state()
		SONICWIND:
			sonicwind_state()
		JUMP:
			jump()
		DOUBLEJUMP:
			double_jump()
		
	player_pos = self.position
	Signals.emit_signal("player_position_update", player_pos)
	####################################31 21 #8
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	
	if Health <= 0:
		Health = 0
		animPlayer.play("Death")
		await animPlayer.animation_finished
		queue_free()
		get_tree().change_scene_to_file("res://menu.tscn")
	
	move_and_slide()

func move_state():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED * run_speed
		if velocity.y == 0:
			if run_speed == 1:
				animPlayer.play("Steps")
			else:
				animPlayer.play("Run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
			
	if velocity.length() == 0 and is_on_floor():
		idle_timer += 1
		if idle_timer > IDLE_INTERVAL:
			animPlayer.play("Idle1")
			await animPlayer.animation_finished
			idle_timer = 0
		else:
			animPlayer.play("Idle")
	

	
	if direction == 1 or velocity.x > 0:
		$AnimatedSprite2D.flip_h = true
		
	elif direction == -1 or velocity.x < 0:
		$AnimatedSprite2D.flip_h = false
	if Input.is_action_pressed("Run"):
		run_speed = 2
	else:
		run_speed = 1
	if Input.is_action_pressed("block") and is_on_floor():
		if velocity.x == 0:
			state = BLOCK
		else:
			state = SLIDE
			
	if Input.is_action_just_pressed("attack") and attack_cooldown == false:
		state = ATTACK1
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		state = JUMP

func block_state():
	animPlayer.play("Block")
	if Input.is_action_just_released("block"):
		state = MOVE
		

func slide_state():
	velocity.y = 0
	animPlayer.play("Slide")
	await animPlayer.animation_finished
	state = MOVE

func attack_state():
	if Input.is_action_just_pressed("attack") and Combo == true:
		state = ATTACK2
	velocity.x = 0
	animPlayer.play("Attack1")
	await animPlayer.animation_finished
	attack_freze()
	state = MOVE

func attack2_state():
	if Input.is_action_just_pressed("attack") and Combo == true:
		state = ATTACK3
	
	animPlayer.play("Attack2")
	await animPlayer.animation_finished
	state = MOVE

func attack3_state():
	if Input.is_action_just_pressed("attack") and Combo == true:
		state = SONICWIND
	
	animPlayer.play("Attack3")
	await animPlayer.animation_finished
	state = MOVE

func sonicwind_state():
	animPlayer.play("SonicWind")
	await animPlayer.animation_finished
	state = MOVE

func combo1():
	Combo = true
	await animPlayer.animation_finished
	Combo = false

func attack_freze():
	attack_cooldown = true
	await get_tree().create_timer(0.5).timeout
	attack_cooldown = false

func jump():
	jumps = 0
	velocity.y = JUMP_VELOCITY
	animPlayer.play("Jump")
	if jumps < MAXJUMPS:
		state = DOUBLEJUMP


func double_jump():
	if Input.is_action_just_pressed("jump") and jumps < MAXJUMPS:
		jumps += 1
		velocity.y += DJUMP
		animPlayer.play("Double jump")
	if is_on_floor():
		state = MOVE
