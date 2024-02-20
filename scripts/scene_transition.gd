extends CanvasLayer

@export var animationPlayer : AnimationPlayer

func change_scene (destinationLevel: PackedScene) -> void:
	#animationPlayer.play("dissolve")
	
	var world = $"../World"
	
	var instance = destinationLevel.instantiate()
	world.add_child(instance)

#func _on_animation_player_animation_finished(anim_name):
	#get_tree().change_scene_to_packed(target)
	#$AnimationPlayer.play_backwards("dissolve")
