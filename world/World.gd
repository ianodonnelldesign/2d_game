extends Node


@onready var startScreen = $StartScreen
@onready var address_entry = $StartScreen/Panel/MainMenu/PanelContainer/MarginContainer/VBoxContainer/AddressEntry

const gameWorld = preload("res://level/Floor_F1.tscn")
const Player = preload("res://player/2d_player.tscn")

const PORT = 9999
var enet_peer = ENetMultiplayerPeer.new()


func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func _on_new_game_pressed():
	startScreen.queue_free()
	var instance = gameWorld.instantiate()
	add_child(instance)
	add_player(1)

func _on_host_button_pressed():
	startScreen.queue_free()
	
	enet_peer.create_server(PORT)
	multiplayer.multiplayer_peer = enet_peer
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(remove_player)
	
	var instance = gameWorld.instantiate()
	add_child(instance)
	add_player(multiplayer.get_unique_id())
	
	upnp_setup()

func _on_join_button_pressed():
	startScreen.queue_free()
	
	enet_peer.create_client(address_entry.text, PORT)
	multiplayer.multiplayer_peer = enet_peer

func add_player(peer_id):
	var player = Player.instantiate()
	player.name = str(peer_id)
	add_child(player)

func remove_player(peer_id):
	var player = get_node_or_null(str(peer_id))
	if player:
		player.queue_free()


func upnp_setup():
	var upnp = UPNP.new()
	var discover_result = upnp.discover()

	if discover_result == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			
			var map_result_udp = upnp.add_port_mapping(9999, 9999, "godot_udp", "UDP", 0)
			var map_result_tcp = upnp.add_port_mapping(9999, 9999, "godot_tcp", "TCP", 0)
			
			if not map_result_udp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(9999,9999, "", "UDP")
			if not map_result_tcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(9999,9999, "", "TCP")
	
	var external_ip = upnp.query_external_address()
	
	print("Success! Join Address: %s" % external_ip)
