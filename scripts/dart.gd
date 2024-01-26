extends Area2D

var speed = 450 # dart speed
var time_remaining = 2.5 # seconds to stay alive
var velocity = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta
	#move_and_slide()

	time_remaining -= delta
	
	if time_remaining <= 0:
		queue_free()

# This function will spawn a dart at the player, set the velocity to the mouse click,
# and rotate the dart to match the direction of travel.
func initiate(player_pos, mouse_pos):
	position = player_pos
	var direction = mouse_pos - player_pos
	
	# Set the velocity and rotation based on the mouse position
	velocity = direction.normalized() * speed
	rotation = direction.angle()
	

func _on_body_entered(body):
	pass
