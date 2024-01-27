extends CharacterBody2D
class_name Player

@export var gravity = 400
@export var speed = 250
@export var jump_force = 240

@onready var animated_sprite = $AnimatedSprite2D
@onready var DartSpawn = $DartSpawn
@onready var camera = $Camera2D

var active = true
var dart_count : int = 0
var ZOOM_FACTOR = 0.15
var DEFAULT_ZOOM = 0.9
var MAX_ZOOM = 0.6
var CAMERA_POSITION_INCREMENT = 3

func _physics_process(delta):
	if is_on_floor() == false:
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500
		
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
		
	velocity.x = direction * speed
	move_and_slide()
	
	update_animations(direction)
	
	if abs(velocity.y) > 0:
		if camera.zoom.x > MAX_ZOOM:
			camera.zoom.x -= ZOOM_FACTOR * delta
			camera.zoom.y -= ZOOM_FACTOR * delta
			
		if camera.position.y < 300:
			camera.position.y += CAMERA_POSITION_INCREMENT
		
	elif camera.zoom.x < DEFAULT_ZOOM:
		camera.zoom.x += ZOOM_FACTOR * 3 * delta
		camera.zoom.y += ZOOM_FACTOR * 3 * delta
		
		if camera.position.y > 0:
			camera.position.y -= CAMERA_POSITION_INCREMENT * 3
	

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
	velocity.y = -force
		
		
func bounce(whoopee_force, whoopee_position):
	if position.y < whoopee_position.y:
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
