extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var multiplayer_handler: Node
@onready var text_edit: TextEdit = $MultiplayerHandler/Port
@onready var color: TextEdit = $MultiplayerHandler/Color

var port: int

func _ready() -> void:
	multiplayer_handler.show()

func _on_host_pressed():
	port = int(text_edit.text)
	peer.create_server(port)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()
	
	finish_multiplayer()

func _add_player(id = 1):
	var player = player_scene.instantiate()
	player.name = str(id)
	call_deferred("add_child", player)
	# Set color locally for the host's own player
	if id == multiplayer.get_unique_id():
		player.modulate = Color(color.text)
		# Send the color to all other peers
		rpc("_set_player_color", id, color.text)

func _on_join_pressed() -> void:
	port = int(text_edit.text)
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	
	finish_multiplayer()

func _on_connected_to_server():
	# Send our color to the server after connecting
	rpc_id(1, "_receive_player_color", multiplayer.get_unique_id(), color.text)

@rpc("any_peer", "reliable")
func _receive_player_color(player_id: int, player_color: String):
	# Host receives the color from a joining player
	var player = get_node_or_null(str(player_id))
	if player:
		player.modulate = Color(player_color)
	# Forward the color to all other players
	rpc("_set_player_color", player_id, player_color)

@rpc("any_peer", "reliable")
func _set_player_color(player_id: int, player_color: String):
	# Apply color to the specified player
	var player = get_node_or_null(str(player_id))
	if player:
		player.modulate = Color(player_color)

func finish_multiplayer():
	multiplayer_handler.hide()
