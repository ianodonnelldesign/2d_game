extends Area2D

@export var attackDamage: = 1.0
@export var knockback: = 10.0
var attackPosition

func _on_area_entered(area):
	if area is HurtboxComponent:
		#print("Hitbox entered a hurtbox")
		var hurtbox : HurtboxComponent = area
		
		var attack = Attack.new()
		attack.attackDamage = attackDamage
		attack.knockback = knockback
		attack.attackPosition = global_position
		area.damage(attack)
