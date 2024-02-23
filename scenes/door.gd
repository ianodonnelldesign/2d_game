extends Area2D
class_name Door

@export var destination_level_tag: PackedScene
@export var destination_door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

func _on_body_entered(body):
	print(body.name + " entered " + self.name)
	var door = self as Door
	
	if body is Player && !NavigationManager.DoorList.has(door.name):
		NavigationManager.go_to_level(destination_level_tag, destination_door_tag)
		NavigationManager.add_door(door.name, door)

	if NavigationManager.DoorList.has(door.destination_door_tag):
		NavigationManager.find_door(door.destination_door_tag)
