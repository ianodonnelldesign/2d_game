extends State
class_name PlayerIdle

@onready var player = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func State_Update(delta: float):
	#Get the Player, and then get_input from the movement script
	player.get_input()
	
	#Change the animation based on the player's movement
	if player.velocity.length() > 1:
		animation_player.play("move")
	if player.velocity.length() < 1:
		animation_player.play("idle")
