extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
@export var multiplayer_handler: Node
@onready var text_edit: TextEdit = $MultiplayerHandler/Port
@onready var color: TextEdit = $MultiplayerHandler/Color

var port: int

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
	player.modulate = color.text
	call_deferred("add_child", player)

func _on_join_pressed() -> void:
	port = int(text_edit.text)
	peer.create_client("localhost", port)
	multiplayer.multiplayer_peer = peer
	
	finish_multiplayer()

func finish_multiplayer():
	multiplayer_handler.hide()
