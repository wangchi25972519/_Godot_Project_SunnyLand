extends "res://Scenes/Enemy.gd"


enum Direction {LEFT = -1, RIGHT = 1 }

const max_speed = 100
const jump_force = 150
const acceleration = 10 / 0.2
const air_acceleration = max_speed / 0.05

var velocity = Vector2.ZERO
export(Direction) var direction = Direction.LEFT


func _physics_process(delta):
	var was_on_wall  = is_on_wall()
	var snap = Vector2.ZERO
	velocity = move_and_slide_with_snap(velocity, snap, Vector2.UP)
	#velocity = move_and_slide(velocity, Vector2.UP)
	if is_on_floor():
		sprite.play("idle")                   ##放在_physics_process效果正确，放在_process效果不正确
	
	if not is_on_floor() and velocity.y > 0:
		sprite.play("fall")                    ##放在_physics_process效果正确，放在_process效果不正确
		
	if is_on_wall() and not was_on_wall:
		direction *= -1
		
func _process(delta):	
	var acc  = acceleration if is_on_floor() else air_acceleration
	
	if is_on_floor():
		velocity.x = move_toward(velocity.x, 10 * direction, acc*delta)
	else:
		velocity.x = move_toward(velocity.x, 30 * direction, acc*delta)
		
	velocity.y += gravity * delta
	sprite.flip_h = velocity.x >0

func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation == "idle"):
		if is_on_floor():
			velocity.y =  -jump_force
			sprite.play("jump")
