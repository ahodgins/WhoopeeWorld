extends Area2D

@onready var animtated_sprite = $AnimatedSprite2D

func animate():
	animtated_sprite.play("default")
