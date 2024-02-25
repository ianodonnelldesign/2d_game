extends CharacterBody2D
class_name Player

#Mouse and Camera
var mouseCapture = true
@onready var camera = $Camera2D

#Movement
@export var playerSpeed = 100
@export var acceleration: int = 40
const friction = 0.15
var moveDirection = Vector2.ZERO

@export var knockbackModifier = 1.0

#Inventory
@export var inventory_data: InventoryData
@export var equip_inventory_data: InventoryDataEquip
@onready var inventory_interface = $"PlayerUI/Inventory Interface"
@onready var drop_position = $DropPosition
@onready var hot_bar_inventory = $PlayerUI/HotBarInventory

#Hands
@onready var hand1 = $Hand1
@onready var holdItem1 =  hand1.get_child(0)
@onready var hand2 = $Hand2
@onready var holdItem2 =  hand2.get_child(0)

#Sprite
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
	
	inventory_interface.set_player_inventory_data(self.inventory_data)
	inventory_interface.set_equip_inventory_data(self.equip_inventory_data)
	hot_bar_inventory.set_inventory_data(self.inventory_data)
	
	NavigationManager.on_trigger_player_spawn.connect(player_spawn)

func player_spawn(position: Vector2, direction: String):
	global_position = position
	#can animate the player walking through the door here

func _process(_delta: float) -> void:
	if not is_multiplayer_authority(): return
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()

	if get_global_mouse_position().x > global_position.x:
		animated_sprite.scale.x = 1
	elif get_global_mouse_position().x < global_position.x:
		animated_sprite.scale.x = -1
	
	if holdItem1 != null:
		holdItem1.rotation = mouse_direction.angle()
		if holdItem1.scale.y == 1 and mouse_direction.x < 0:
			holdItem1.scale.y = -1
		elif holdItem1.scale.y == -1 and mouse_direction.x > 0:
			holdItem1.scale.y = 1
	
	if holdItem2 != null:
		holdItem2.rotation = mouse_direction.angle()
		if holdItem2.scale.y == 1 and mouse_direction.x < 0:
			holdItem2.scale.y = -1
		elif holdItem2.scale.y == -1 and mouse_direction.x > 0:
			holdItem2.scale.y = 1
	
	if Input.is_action_pressed("use_item1") and holdItem1 != null:
		holdItem1.use_item()
	if Input.is_action_pressed("use_item2") and holdItem2 != null:
		holdItem2.use_item()

func _unhandled_input(event):
	if Input.is_action_just_pressed("inventory_action"):
		inventory_interface.visible = not inventory_interface.visible
		hot_bar_inventory.visible = not hot_bar_inventory.visible

func get_input() -> void:
	if not is_multiplayer_authority(): return

	var moveDirection = Input.get_vector("left", "right", "forward", "backward")
	if moveDirection:
		velocity = moveDirection * acceleration
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		velocity.y = move_toward(velocity.y, 0, acceleration)
		
	move_and_slide()
