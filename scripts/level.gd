extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false
@export var current_level: int
#@export var total_whoopee_layers: int = 1
var number_of_tut_levels = 7

var min_ppm = 150
var max_ppm = 320
var target_ppm = 280
var displayed_ppm
var display_ppm_warning = false
var warning_countdown = 3
var total_whoopee_layers = 0

@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $deathzone
@onready var level_label = $HUD/LevelPanel/LevelCounter
@onready var darts_label = $HUD/DartsPanel/DartsCounter
@onready var popped_label = $HUD/PoppedPanel/PoppedCounter
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
	
	level_label.text = "Level: " + str(current_level)
	if current_level >= 8:
		$HUD/PPMWarning.visible = false
		
	else:
		pass
		#level_label.text = "Level: " + str(current_level) 
	
	# Count up all the layers to pop in the whoopees
	var whoopee_cushions = whoopees.get_children()
	for cushion in whoopee_cushions:
		total_whoopee_layers += cushion.get_layers()

func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	# Display the number of darts the player has.
	if player.dart_count > 0 or current_level >= 4:
		darts_label.visible = true
		darts_label.text = "Darts: " + str(player.dart_count)
		
	else:
		darts_label.visible = false
		
	# We only show local co2 ppm after tutorial
	if current_level >= 8:
		# Use the number of whoopees popped and the total number of whoopee layers on the level
		# to calculate the ppm, with a perfect run as 320 ppm but 280 ppm is enough to beat the level!
		var fraction_popped = float(player.whoopees_popped) / float(total_whoopee_layers)
		displayed_ppm = snapped(min_ppm + (max_ppm - min_ppm) * fraction_popped, 1)
		popped_label.text = 'Local CO2 ppm: ' + str(displayed_ppm)
		
		# If the user fails to get over 280ppm co2, begin a warning message.
		if display_ppm_warning:
			player.active = false
			if warning_countdown > 2.5:
				$HUD/PPMWarning.visible = true
				
			elif warning_countdown > 2.0:
				$HUD/PPMWarning.visible = false
				
			elif warning_countdown > 1.5:
				$HUD/PPMWarning.visible = true
				
			elif warning_countdown > 1.0:
				$HUD/PPMWarning.visible = false
				
			elif warning_countdown > 0.5:
				$HUD/PPMWarning.visible = true
				
			warning_countdown -= delta

			if warning_countdown <= 0:
				display_ppm_warning = false
				warning_countdown = 3
				$HUD/PPMWarning.visible = false
				get_tree().reload_current_scene()
				
	if player.dead:
		get_tree().reload_current_scene()


func _on_deathzone_body_entered(body):
	reset_player()


func _on_trap_touched_player():
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
	get_tree().reload_current_scene()
	
func _on_exit_body_entered(body):
	if body is Player:
		if next_level != null:
			exit.animate()
			player.active = false
			
			if current_level >= 8:
				if displayed_ppm >= 280:
					get_tree().change_scene_to_packed(next_level)
					
				else:
					display_ppm_warning = true
					
			else:
				get_tree().change_scene_to_packed(next_level)
			
		else:
			get_tree().unload_current_scene()
			
