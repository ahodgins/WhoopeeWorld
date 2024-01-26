extends Area2D

@export var jump_force = 300

@onready var animated_sprite = $AnimatedSprite2D

func _on_body_entered(body):
	print(body.position)
	if body is Player:
		animated_sprite.play("jump")
		body.jump(jump_force)

func _on_whoopee_body_exited(body):
	if body is Player:
		animated_sprite.play("idle")
		
		
# Later we can add a pop animation and sound here.
func pop():
	queue_free()
