extends State
class_name EnemyFollow

@onready var enemy = $"../.."

var speed = 100.0
var playerChase = false
var player = null

func State_Physics_Update(delta):
	if playerChase:
		enemy.move_and_collide(Vector2.ZERO)
		enemy.position += (player.position - enemy.position) / speed
		$"../../AnimatedSprite2D".play("move")
		if(player.position.x - enemy.position.x) < 0:
			$"../../AnimatedSprite2D".flip_h = true
		else:
			$"../../AnimatedSprite2D".flip_h = false

func _on_detection_area_body_entered(body):
	if body.collision_layer == 2:
			player = body
			playerChase = true

func _on_detection_area_body_exited(body):
	playerChase = false
	Transitioned.emit(self, "EnemyIdle")
