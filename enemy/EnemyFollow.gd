extends State
class_name EnemyFollow

@onready var enemy = $"../.."
@onready var navigation_agent = $"../../NavigationAgent2D"
@onready var path_timer = $"../../Timer"

@export var speed = 10
@export var acceleration = 2
@export var chaseRange = 150

const friction = 0.15 
var moveDir = Vector2.ZERO
var playerChase = false
var player = null

func State_Physics_Update(delta):
	if playerChase:
		_get_path_to_player()
		enemy_move()

		if(player.position.x - enemy.position.x) < 0:
			$"../../AnimatedSprite2D".flip_h = true
		else:
			$"../../AnimatedSprite2D".flip_h = false

func enemy_move():
	if not navigation_agent.is_target_reached():
		var vector_to_next_point = navigation_agent.get_next_path_position() - enemy.global_position
		moveDir = vector_to_next_point
	
	#check if the player is out of range
	var distanceToPlayer = player.global_position - enemy.global_position
	if distanceToPlayer.x > chaseRange || distanceToPlayer.y > chaseRange:
		playerChase = false
	
	
	moveDir = moveDir.normalized()
	enemy.velocity += moveDir * acceleration

func _on_timer_timeout() -> void:
	if is_instance_valid(player):
		_get_path_to_player()
	else:
		path_timer.stop()
		moveDir = Vector2.ZERO

func _get_path_to_player() -> void:
	navigation_agent.target_position = player.position

func _on_detection_area_body_entered(body):
	if body.collision_layer == 2:
			player = body
			playerChase = true

func _on_detection_area_body_exited(body):
	if moveDir < Vector2.ZERO:
		playerChase = false
		Transitioned.emit(self, "EnemyIdle")


