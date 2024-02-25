extends Control

signal drop_slot_data(slot_data: SlotData)

const pickup = preload("res://item/pickup/pick_up.tscn")
var grabbed_slot_data: SlotData

@onready var player = get_owner()
@onready var grabbed_slot = $GrabbedSlot
@onready var player_inventory = $PlayerInventory
@onready var equip_inventory = $EquipInventory

func _physics_process(delta):
	if grabbed_slot.visible:
		grabbed_slot.global_position = get_global_mouse_position() + Vector2(3, 3)

func set_player_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	player_inventory.set_inventory_data(inventory_data)

func set_equip_inventory_data(inventory_data: InventoryData) -> void:
	inventory_data.inventory_interact.connect(on_inventory_interact)
	equip_inventory.set_inventory_data(inventory_data)

func on_inventory_interact(inventory_data: InventoryData, index: int, button: int) -> void:
	match [grabbed_slot_data, button]:
		[null, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.grab_slot_data(index)
			if inventory_data is InventoryDataEquip:
				player.unequip_item(index)
			if inventory_data is InventoryDataGear:
				print("is gear")
		[_, MOUSE_BUTTON_LEFT]:
			grabbed_slot_data = inventory_data.drop_slot_data(grabbed_slot_data, index)
			#if we put this item in an Equipment slot, do something
			if inventory_data is InventoryDataEquip:
				player.equip_item()
			if inventory_data is InventoryDataGear:
				print("is gear")
		[null, MOUSE_BUTTON_RIGHT]:
			inventory_data.use_slot_data(index)
		[_, MOUSE_BUTTON_RIGHT]:
			grabbed_slot_data = inventory_data.drop_single_slot_data(grabbed_slot_data, index)
			if inventory_data is InventoryDataEquip:
				player.equip_item()

	update_grabbed_slot()

func update_grabbed_slot() -> void:
	if grabbed_slot_data:
		grabbed_slot.show()
		grabbed_slot.set_slot_data(grabbed_slot_data)
	else:
		grabbed_slot.hide()

func _on_gui_input(event):
	if event is InputEventMouseButton \
			and event.is_pressed() \
			and grabbed_slot_data:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				drop_slot_data.emit(grabbed_slot_data)
				grabbed_slot_data = null
			MOUSE_BUTTON_RIGHT:
				drop_slot_data.emit(grabbed_slot_data.create_single_slot_data())
				if grabbed_slot_data.quantity < 1:
					grabbed_slot_data = null
	update_grabbed_slot()

func _on_drop_slot_data(slot_data):
	var pick_up = pickup.instantiate()
	pick_up.slot_data = slot_data
	pick_up.position = get_owner().drop_position.global_position
	get_owner().get_parent().add_child(pick_up)

func _on_visibility_changed():
	if not visible and grabbed_slot_data:
		drop_slot_data.emit(grabbed_slot_data)
		grabbed_slot_data = null
		update_grabbed_slot()
