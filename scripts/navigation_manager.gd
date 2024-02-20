extends Node

var spawn_door_tag : String
signal on_trigger_player_spawn

func go_to_level(destination_level_tag, destination_door_tag):
	var scene_to_load = destination_level_tag
	
	if scene_to_load != null:
		spawn_door_tag = destination_door_tag
		SceneTransition.change_scene(destination_level_tag)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
