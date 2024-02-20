extends Area2D
class_name HurtboxComponent

@export var healthComponent : HealthComponent
@onready var hitbox = get_owner()

func damage(attack: Attack):
	if healthComponent:
		healthComponent.damage(attack)
	
		var knockback_direction = attack.attackPosition.direction_to(self.global_position)
		var knockback = knockback_direction * attack.knockback
		hitbox.global_position += knockback
	else:
		return
