extends State
class_name EnemyIdle

var playerChase = false
var player = null

func State_Physics_Update(delta):
	$"../../AnimatedSprite2D".play("idle")

	if playerChase:
		Transitioned.emit(self, "EnemyFollow")

func _on_detection_area_body_entered(body):
	if body.collision_layer == 2:
		playerChase = true
