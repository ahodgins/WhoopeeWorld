extends Area2D

var DEFAULT_JUMP_FORCE = 69 * 2
var JUMP_FORCE_INCREMENT = 50
@export var jump_force = DEFAULT_JUMP_FORCE

@export var starting_colour = 'red'
@onready var animated_sprite = $AnimatedSprite2D

@onready var pink_fart_sound = $pink
@onready var red_fart_sound = $red
@onready var purple_fart_sound = $purple
@onready var blue_fart_sound = $blue
@onready var green_fart_sound = $green
@onready var yellow_fart_sound = $yellow
@onready var orange_fart_sound = $orange

func _ready():
	if starting_colour == 'red':
		animated_sprite.play("red_idle")
		
	elif starting_colour == 'orange':
		animated_sprite.play("orange_idle")
		
	elif starting_colour == 'yellow':
		animated_sprite.play("yellow_idle")
		
	elif starting_colour == 'green':
		animated_sprite.play("green_idle")
		
	elif starting_colour == 'blue':
		animated_sprite.play("blue_idle")
		
	elif starting_colour == 'purple':
		animated_sprite.play("purple_idle")
		
	elif starting_colour == 'pink':
		animated_sprite.play("pink_idle")

func _on_body_entered(body):
	if body is Player:
		print('\nplayer enters')		
		play_fart_sound()
		jump_force = set_jump_force()
		body.bounce(jump_force, position)
		
		change_colour()
		
	if body is Dart:
		body.queue_free()
		pop()

func _on_whoopee_body_exited(body):
	print('\nplayer exits')
	if body is Player:
		change_colour()
		
	
		
# Later we can add a pop animation and sound here.
func pop():
	print('POP')
	queue_free()
	
	const SMOKE_SCENE = preload("res://scenes/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	
	get_parent().add_child(smoke)
	smoke.global_position = global_position
	
	
func change_colour():
	print('animation was ' + animated_sprite.animation)
	if animated_sprite.animation == 'pink_idle':
		animated_sprite.play("purple_pop")
			
	elif animated_sprite.animation == 'purple_pop':
		animated_sprite.play("purple_idle")
			
	elif animated_sprite.animation == 'purple_idle':
		animated_sprite.play("blue_pop")
			
	elif animated_sprite.animation == 'blue_pop':
		animated_sprite.play("blue_idle")
		
	elif animated_sprite.animation == 'blue_idle':
		animated_sprite.play("green_pop")
			
	elif animated_sprite.animation == 'green_idle':
		animated_sprite.play("yellow_pop")
			
	elif animated_sprite.animation == 'green_pop':
		animated_sprite.play("green_idle")
			
	elif animated_sprite.animation == 'yellow_idle':
		animated_sprite.play("orange_pop")
			
	elif animated_sprite.animation == 'yellow_pop':
		animated_sprite.play("yellow_idle")
			
	elif animated_sprite.animation == 'orange_idle':
		animated_sprite.play("red_pop")
			
	elif animated_sprite.animation == 'orange_pop':
		animated_sprite.play("orange_idle")
		
	elif animated_sprite.animation == 'red_pop':
		animated_sprite.play("red_idle")
		
	elif animated_sprite.animation == 'red_idle':
		pop()
		
	print('animation is now ' + animated_sprite.animation)
	
	
func set_jump_force():
	if "pink" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE
			
	elif "purple" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE + JUMP_FORCE_INCREMENT

	elif "blue" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE + JUMP_FORCE_INCREMENT*2
		
	elif "green" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE + JUMP_FORCE_INCREMENT*3
		
	elif "yellow" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE + JUMP_FORCE_INCREMENT*4
		
	elif "orange" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE + JUMP_FORCE_INCREMENT*5
		
	elif "red" in animated_sprite.animation:
		jump_force = DEFAULT_JUMP_FORCE + JUMP_FORCE_INCREMENT*6
		
	return jump_force
	
func play_fart_sound():
	if "pink" in animated_sprite.animation:
		pink_fart_sound.play()
			
	elif "purple" in animated_sprite.animation:
		purple_fart_sound.play()

	elif "blue" in animated_sprite.animation:
		blue_fart_sound.play()
		
	elif "green" in animated_sprite.animation:
		green_fart_sound.play()
		
	elif "yellow" in animated_sprite.animation:
		yellow_fart_sound.play()
		
	elif "orange" in animated_sprite.animation:
		orange_fart_sound.play()
		
	elif "red" in animated_sprite.animation:
		red_fart_sound.play()
