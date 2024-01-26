extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var current_level: int

@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $deathzone
@onready var level_label = $HUD/LevelPanel/LevelCounter
@onready var darts_label = $HUD/DartsPanel/DartsCounter
@onready var whoopees = $Whoopees

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)
		
	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	# Set the level
	level_label.text = "Level: " + str(current_level)
	
	# Add all whoopees to a group
	var whoopee_cushions = whoopees.get_children()
	
	for cushion in whoopee_cushions:
		cushion.add_to_group("whoopee_group")

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	# Display the number of darts the player has.
	if current_level > 3:
		darts_label.text = "Darts: " + str(player.dart_count)


func _on_deathzone_body_entered(body):
	reset_player()


func _on_trap_touched_player():
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
func _on_exit_body_entered(body):
	if body is Player:
		if next_level != null:
			exit.animate()
			player.active = false
			
			get_tree().change_scene_to_packed(next_level)
			
		else:
			get_tree().unload_current_scene()


func _on_whoopee_body_exited(body):
	if body is Player:
		if next_level != null:
			exit.animate()
			player.active = false
			
			get_tree().change_scene_to_packed(next_level)
			
		else:
			get_tree().unload_current_scene()
