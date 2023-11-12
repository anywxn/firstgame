extends Node2D
@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("default")


func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	get_tree().change_scene_to_file("res://ScenceAndScripts/level.tscn")
