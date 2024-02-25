extends Node2D
class_name HoldItem

@onready var itemAnimationPlayer = $AnimationPlayer

func use_item():
	if itemAnimationPlayer != null:
		itemAnimationPlayer.play("use_item")
