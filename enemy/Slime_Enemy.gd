extends CharacterBody2D
class_name Enemy

@export var knockbackModifier = 1.0
const friction = 0.15
@onready var inCombat = false

func _physics_process(delta):
	velocity = lerp(velocity, Vector2.ZERO, friction)
	move_and_slide()
