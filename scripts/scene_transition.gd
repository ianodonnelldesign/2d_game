extends CanvasLayer

@onready var animationPlayer = $AnimationPlayer

func change_scene (destinationLevel: PackedScene) -> void:
	#animationPlayer.play("dissolve")
	
	var world = $"../World"
	
	var instance = destinationLevel.instantiate()
	world.add_child(instance)

#func _on_animation_player_animation_finished(anim_name):
	#animationPlayer.play_backwards("dissolve")
