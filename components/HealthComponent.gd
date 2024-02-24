extends State
class_name HealthComponent

@export var maxHealth = 10.0
var health : float
@onready var stateMachine = $".."

func _ready():
	health = maxHealth

func damage(attack: Attack):
	health -= attack.attackDamage
	Transitioned.emit(self, "EnemyFollow")
	
	if health <= 0:
		Transitioned.emit(stateMachine.currentState, "Dead")
