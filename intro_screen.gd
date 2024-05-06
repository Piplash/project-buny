extends Control

@onready var anim = $SceneChange/Intro
@onready var anim2 = $SceneChange/IntroToMain

func _ready():
	anim.play("fade_out")
	await get_tree().create_timer(3).timeout
	#anim2.play("fade_out")
	#await get_tree().create_timer(0.5).timeout
	#get_tree().change_scene_to_file("res://MainMenu.tscn")
	get_tree().change_scene_to_file("res://Room.tscn")
