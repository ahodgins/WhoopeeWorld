extends Area2D

var num_darts_in_collectable = 50

func _on_body_entered(body):
	if body is Player:
		body.add_darts(num_darts_in_collectable)
		queue_free()
