extends Control


func _ready():
	$ThemeSong.play()
	
func _on_start_pressed():
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
	


func _on_quit_pressed():
	get_tree().quit()




func _on_credits_pressed():
	get_tree().change_scene_to_file("res://scenes/credits.tscn")
