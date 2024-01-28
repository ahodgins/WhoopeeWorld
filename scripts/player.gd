extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var speed = 250 * 60
@export var jump_force = 240

@onready var animated_sprite = $AnimatedSprite2D
@onready var DartSpawn = $DartSpawn
@onready var camera = $Camera2D
@onready var ouch_sound = $ouch_sound
@onready var fall_sound = $fall_sound
@onready var footsteps = $footsteps
@onready var jump_sound = $jump_sound

var active = true
var dart_count : int = 0
var whoopees_popped : int = 0
var ZOOM_FACTOR = 0.15
var DEFAULT_ZOOM = 0.9
var MAX_ZOOM = 0.6
var MAX_FALL_SPEED = 500

var dead = false


func _physics_process(delta):
	if is_on_floor() == false:
		if footsteps.playing:
			footsteps.stop()
			
		velocity.y += gravity * delta
		if velocity.y > MAX_FALL_SPEED:
			velocity.y = MAX_FALL_SPEED
			
	else:
		if abs(velocity.x) > 0:
			if not footsteps.playing:
				footsteps.play()
				
		else:
			footsteps.stop()
		
	var direction = 0
	if active == true:
		if Input.is_action_just_pressed("jump") && is_on_floor():
			jump(jump_force)
			
		if Input.is_action_just_pressed("fire_dart"):
			var mouse_pos = get_global_mouse_position()
			fire_dart(mouse_pos)
			
		direction = Input.get_axis("move_left","move_right")
	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
		
	velocity.x = direction * speed * delta
	move_and_slide()
	
	for index in get_slide_collision_count():
		var collision := get_slide_collision(index)
		var body := collision.get_collider()
		
		if 'Enemy' in body.name:
			initiate_die_ouch(body)
	
	update_animations(direction)
	
	if abs(velocity.y) > 0:
		if camera.zoom.x > MAX_ZOOM:
			camera.zoom.x -= ZOOM_FACTOR * delta
			camera.zoom.y -= ZOOM_FACTOR * delta
		
	elif camera.zoom.x < DEFAULT_ZOOM:
		camera.zoom.x += ZOOM_FACTOR * 3 * delta
		camera.zoom.y += ZOOM_FACTOR * 3 * delta
	

# Fire dart uses the mouse position when a user clicks to set a target, and
# the player position as the spawn point for the dart.
func fire_dart(mouse_pos):
	if dart_count > 0:
		const DART = preload("res://scenes/dart.tscn")
		var dart = DART.instantiate()
		
		get_parent().add_child(dart)
		dart.initiate(DartSpawn.global_position, mouse_pos)
		
		dart_count -= 1
		print('dart fired')
		
	else:
		# Could play an "empty" sound or something to show the player has no darts.
		pass
	
	
func jump(force):
	jump_sound.play()
	velocity.y = -force
		
		
func bounce(whoopee_force, whoopee_position):
	if velocity.y > 0:
		velocity.y = -whoopee_force
		
	else:
		velocity.y = whoopee_force * 0.85


func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
			
			
func add_darts(num_darts):
	dart_count += num_darts


func add_popped_whoopees(layers_popped):
	whoopees_popped += layers_popped


func initiate_die_ouch(body):
	print('hey')
	for child in body.get_children():
		print(child.name)
		if child.name == 'penguin':
			print(child.animation)
			if child.animation != 'death':
				dead = true
	
	#could play some animations or sound here if needed...?
