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
@onready var hand2 = $Hand2
var holdItem1
var holdItem2

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
	######################
	######################
	#FIX THIS. It only needs to be checked once, after something is instanced as hand's child
	######################
	######################
	if hand1.get_child(0) != null:
		holdItem1 = hand1.get_child(0)
	if hand2.get_child(0) != null:
		holdItem2 = hand2.get_child(0)
	
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
		print("used offhand item")

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

func equip_item():
	#can probably pass the index here to better tell when to add
	
	var holdItem1 = hand1.get_child(0)
	var holdItem2 = hand2.get_child(0)
	
	if equip_inventory_data.slot_datas[0]:
		var inventory_item = equip_inventory_data.slot_datas[0]
		var holdItem = inventory_item.item_data.holdItem
		var instance = holdItem.instantiate()
		hand1.add_child(instance)
	
	if equip_inventory_data.slot_datas[1]:
		var inventory_item = equip_inventory_data.slot_datas[1]
		var holdItem = inventory_item.item_data.holdItem
		var instance = holdItem.instantiate()
		hand2.add_child(instance)

func unequip_item(index):
	var holdItem1 = hand1.get_child(0)
	var holdItem2 = hand2.get_child(0)
	
	if index == 0:
		holdItem1.queue_free()
	if index == 1:
		holdItem2.queue_free()
#put something here to remove it too
	
	
	#elif equip_inventory_data.slot_datas[0]:
		#
	#
	#if equip_inventory_data.slot_datas[1]:
		#var holdItem2 = equip_inventory_data.slot_datas[1]
		#var holdItem = holdItem2.holdItem
		#
		#hand2.instantiate(holdItem)
		#hand2.add_child(holdItem)
