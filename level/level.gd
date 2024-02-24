extends Node2D

func _ready():
	if NavigationManager.spawn_door_tag != null:
		on_level_spawn(NavigationManager.spawn_door_tag)

func on_level_spawn(destination_door_tag: String):
	if destination_door_tag != "":
		#print(destination_door_tag)
		var door_path = "Doors/" + destination_door_tag
		#print(door_path)
		var door = get_node(door_path) as Door
		#print(door)
		NavigationManager.trigger_player_spawn(door.spawn.global_position, door.spawn_direction)
