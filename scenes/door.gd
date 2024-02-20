extends Area2D
class_name Door

@export var destination_level_tag: PackedScene
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

func _on_body_entered(body):
	if body is Player:
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
		
	#if NavigationManager.spawn_door_tag != null:
		#Level.enter_door()
	
