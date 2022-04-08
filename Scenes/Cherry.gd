extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Cherry_body_entered(body):
	$AnimationPlayer.play("bounce")
	body.add_sherry()


func _on_AnimationPlayer_animation_finished(anim_name):
	queue_free()
