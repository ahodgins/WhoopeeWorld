extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level: bool = false

@onready var start = $Start
@onready var exit = $Exit

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("Player")
	if player != null:
		player.global_position = start.get_spawn_pos()

	exit.body_entered.connect(_on_exit_body_entered)


func _process(delta):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
		
	elif Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()


func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()
	
	
func _on_exit_body_entered(body):
	if body is Player:
		if next_level != null:
			exit.animate()
			player.active = false
			await get_tree().create_timer(1.5).timeout
			get_tree().change_scene_to_packed(next_level)
			
		else:
			get_tree().unload_current_scene()
