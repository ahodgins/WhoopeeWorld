extends StaticBody2D

@onready var spawn_pos = $SpawnPosition
@onready var start_sound = $StartSound

func _ready():
	start_sound.play()
	
func get_spawn_pos():
	return spawn_pos.global_position
