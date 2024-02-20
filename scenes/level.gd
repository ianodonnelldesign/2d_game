extends Node2D

func _ready():
	if NavigationManager.spawn_door_tag != null:
		on_level_spawn(NavigationManager.spawn_door_tag)

func on_level_spawn(destination_door_tag: String):
	var door_path = "$Doors/" + destination_door_tag
	var door = get_node("Doors/Door_F1") as Door
	NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
