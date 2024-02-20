extends CharacterBody2D
class_name Player

var mouseCapture = true
@onready var camera = $Camera2D

const playerSpeed = 60.0
@export var moveDir = Vector2(0,0)
@export var knockbackModifier = 1.0

@onready var weapon =  $Weapon
@onready var weaponAnimationPlayer = $Weapon/WeaponAnimationPlayer

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _enter_tree():
	set_multiplayer_authority(str(name).to_int())

func _input(InputEvent):
	if Input.is_action_just_pressed("toggleMouse") && !mouseCapture:
		mouseCapture = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("toggleMouse") && mouseCapture:
		mouseCapture = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _ready():
	if not is_multiplayer_authority(): return
	camera.make_current()
	
	NavigationManager.on_trigger_player_spawn.connect(on_spawn)

func on_spawn(position: Vector2, direction: String):
	global_position = position
	#can animate the player walking through the door here

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	if get_global_mouse_position().x > global_position.x:
		animated_sprite.scale.x = 1
	elif get_global_mouse_position().x < global_position.x:
		animated_sprite.scale.x = -1
	
	weapon.rotation = mouse_direction.angle()
	if weapon.scale.y == 1 and mouse_direction.x < 0:
		weapon.scale.y = -1
	elif weapon.scale.y == -1 and mouse_direction.x > 0:
		weapon.scale.y = 1
	
	if Input.is_action_pressed("attack") and not weaponAnimationPlayer.is_playing():
		weaponAnimationPlayer.play("attack")

func get_input() -> void:
	if not is_multiplayer_authority(): return
	moveDir = Vector2.ZERO
	var direction = Input.get_vector("left", "right", "forward", "backward")
	if direction:
		velocity = direction * playerSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, playerSpeed)
		velocity.y = move_toward(velocity.y, 0, playerSpeed)
		
	move_and_slide()
