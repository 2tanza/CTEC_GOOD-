extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	print("this is level 1")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene_to_file("res://level_2.tscn")