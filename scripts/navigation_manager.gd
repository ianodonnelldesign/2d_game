extends Node

var DoorList_name
var DoorList_spawn
var DoorList = {DoorList_name : DoorList_spawn}

@onready var spawn_door_tag : String
signal on_trigger_player_spawn

func go_to_level(destination_level_tag, destination_door_tag):
	var scene_to_load = destination_level_tag
	
	if scene_to_load != null:
		spawn_door_tag = destination_door_tag
		SceneTransition.change_scene(destination_level_tag)

func add_door(door_name, new_door):
	DoorList[door_name] = new_door

func find_door(door_exit_name):
		var door_exit = DoorList.get(door_exit_name) as Door
		print(door_exit.spawn.global_position)
		trigger_player_spawn(door_exit.spawn.global_position, door_exit.spawn_direction)
		print("player went to " + door_exit.name)

func trigger_player_spawn(position: Vector2, direction: String):
	on_trigger_player_spawn.emit(position, direction)
