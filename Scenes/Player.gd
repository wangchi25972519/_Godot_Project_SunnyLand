extends KinematicBody2D

const  gravity = 800
const  speed = 100
const  acceleration  = speed / 0.2 #解说说的是这个是在0.2s内加速到最大
const  air_acceleration = speed / 0.05
const  jump_force = 300


var velocity = Vector2.ZERO
var is_jumping = false

onready var sprite = $AnimatedSprite
onready var coyote_timer = $CoyoteTimer
onready var jump_request_time = $JumpRequestTimer

func _physics_process(delta):
	var was_on_floor = is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		is_jumping = false
	elif was_on_floor and not is_jumping:
		coyote_timer.start()

func _input(event):
	if event.is_action_pressed("jump"):
		jump_request_time.start();
	if event.is_action_released("jump") and velocity.y < -jump_force /2:
		velocity.y =  -jump_force / 2
	
func _process(delta):
	var direction  = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	
	var acc  = acceleration if is_on_floor() else air_acceleration
	velocity.x = move_toward(velocity.x, direction * speed, acc * delta)
	velocity.y += gravity * delta
	
	var can_jump = is_on_floor() or coyote_timer .time_left > 0
	if can_jump and jump_request_time.time_left > 0:
		velocity.y = -jump_force
		is_jumping = true
		jump_request_time.stop()
		coyote_timer.stop()
	
	if is_jumping :
		if velocity.y >0:
			sprite.play("fall")
		else:
			sprite.play("jump")
	elif velocity.x == 0:
		sprite.play("idle")
	else:
		sprite.play("run")
		
	if direction != 0:
		sprite.flip_h = direction < 0
		
