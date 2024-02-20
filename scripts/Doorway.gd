extends Area2D
class_name Doorway

@export var doorwayExit : Node2D

func _on_body_entered(body):
	if body is Player:
		#SceneTransition.change_scene(doorwayExit)
		#body.global_position = doorwayExit.global_position
