extends KinematicBody2D

const  gravity = 800
const  speed = 100
const  jump_force = 300

var velocity = Vector2.ZERO
var is_jumping = false

onready var sprite = $AnimatedSprite

func _physics_process(delta):
	velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		is_jumping = false

func _input(event):
	if event.is_action_pressed("ui_accept") and not is_jumping:
		velocity.y = -jump_force
		is_jumping = true
	
func _process(delta):
	var direction  = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = direction * speed
	velocity.y += gravity * delta
	
	if is_jumping :
		if velocity.y >0:
			sprite.play("fall")
		else:
			sprite.play("jump")
	elif direction == 0:
		sprite.play("idle")
	else:
		sprite.play("run")
		
	if direction != 0:
		sprite.flip_h = direction < 0
		
