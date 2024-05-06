extends Control

@onready var anim = $SceneChange/MainToGame

func _ready():
	await get_tree().create_timer(0.1).timeout
	anim.play("fade_out")

func _input(event):
	if event is InputEventKey and event.keycode == 4194309:
		get_tree().change_scene_to_file("res://Room.tscn")
