#extends Area2D
#
#var speed = 450 # dart speed
#var time_remaining = 2.5 # seconds to stay alive
#var velocity = Vector2(0, 0)
#@onready var dart_collision_shape : CollisionShape2D = $CollisionShape2D
#
#func _ready():
	#pass
	#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta):
	#position += velocity * delta
	##move_and_slide()
#
	#time_remaining -= delta
	#
	#if time_remaining <= 0:
		#queue_free()
#
## This function will spawn a dart at the player, set the velocity to the mouse click,
## and rotate the dart to match the direction of travel.
#func initiate(player_pos, mouse_pos):
	#position = player_pos
	#var direction = mouse_pos - player_pos
	#
	## Set the velocity and rotation based on the mouse position
	#velocity = direction.normalized() * speed
	#rotation = direction.angle()
	#
#
#func _on_Area2D_area_entered(area):
	#if area.is_in_group("Whoopee"):
		#print("Dart collided with Whoopee!")
		#area.pop_whoopee()
		#queue_free()
#
#
extends Area2D

var speed = 450 # dart speed
var time_remaining = 2.5 # seconds to stay alive
var velocity = Vector2(0, 0)
@onready var dart_collision_shape : CollisionShape2D = $CollisionShape2D

const DART_LAYER = 6
const DART_MASK = 1
const WHOOPEE_LAYER = 4
const WHOOPEE_MASK = 1

func _ready():
	dart_collision_shape = $CollisionShape2D
	collision_layer = DART_LAYER
	collision_mask = WHOOPEE_MASK

func _physics_process(delta):
	position += velocity * delta
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

func _on_Area2D_area_entered(area):
	print("Dart collided with something!")
	print("Collided area:", area)
	print("Is in group 'Whoopee':", area.is_in_group("Whoopee"))
	print("Collision layer:", area.collision_layer)
	print("Expected layer:", WHOOPEE_LAYER)

	if area.is_in_group("Whoopee") and area.collision_layer == WHOOPEE_LAYER:
		print("Dart collided with Whoopee!")
		area.pop_whoopee()
		queue_free()

