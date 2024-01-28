extends CharacterBody2D

@export var movement_pattern = 'chase'
@export var start_direction = 'down'
@onready var animation_penguin = $penguin
@onready var death_sound = $death_sound

var player 
var MOVE_SPEED = 69 * 0.3
var x
var y
var start_velocity = 350
var VELOCITY_INC = 25 
var ATTACK_DISTANCE = 500

func _ready():
	play_fly()
			
	player = get_parent().get_node("Player")
	
	x = global_position.x
	y = global_position.y
	
	if start_direction != 'down':
		start_velocity *= -1
	
	if movement_pattern == 'chase':
		velocity = Vector2(0, 0)
		
	elif movement_pattern == 'strafe':
		velocity = Vector2(start_velocity, 0)
		
	elif movement_pattern == 'hover':
		velocity = Vector2(0, start_velocity)
	
func _physics_process(delta):
	if movement_pattern == 'chase':
		chase(delta)
		
	elif movement_pattern == 'strafe':
		strafe(delta)
		
	elif movement_pattern == 'hover':
		hover(delta)
		
	move_and_slide()
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		
		if body is Dart:
			body.queue_free()
			death()

func play_fly():
	animation_penguin.play("flap")
	
func play_attack():
	animation_penguin.play("attack")
	
func play_death():
	animation_penguin.play("death")
	
func chase(delta):
	var direction = global_position.direction_to(player.global_position)
	
	if abs(player.global_position.x - global_position.x) < ATTACK_DISTANCE:
		velocity += direction * MOVE_SPEED**2 * delta
	
func strafe(delta):
	if global_position.x >= x:
		velocity.x -= VELOCITY_INC**2 * delta
		
	else:
		velocity.x += VELOCITY_INC**2 * delta
	
func hover(delta):
	if global_position.y >= y:
		velocity.y -= VELOCITY_INC**2 * delta
		
	else:
		velocity.y += VELOCITY_INC**2 * delta
		
		
func death():
	animation_penguin.play("death")
	death_sound.play()
	await get_tree().create_timer(0.69/2).timeout
	queue_free()
	# maybe play penguin death noise or something.
