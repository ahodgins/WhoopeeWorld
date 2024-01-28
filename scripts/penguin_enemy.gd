extends CharacterBody2D

@onready var animation_penguin = $penguin
#need to add an onready for the player to get position
#@onready var player = Player or @onready var player = get_parent().get_node("player") both have not worked with global position

func _ready():
	play_fly()
	
func _physics_process(delta):
	pass
	#var direction = global_position.direction_to(player.global_position)
	#velocity = direction * 300.0
	#move_and_slide()
	
	#global position keeps crashing the game. 

func play_fly():
	animation_penguin.play("flap")
	
func play_attack():
	animation_penguin.play("attack")
	
func play_death():
	animation_penguin.play("death")
