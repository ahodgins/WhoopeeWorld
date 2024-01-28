extends Node2D

@onready var intro_sound = $IntroSound

func _ready():
	intro_sound.play()

func _process(delta):
	if not intro_sound.playing:
		get_tree().change_scene_to_file("res://scenes/levels/level.tscn")


func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/levels/level.tscn")
