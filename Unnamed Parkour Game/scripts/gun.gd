extends Node2D

@onready var parent: CharacterBody2D = $".."
@export var bullet: PackedScene
@export var spawn_distance: float = 50.0

func _process(delta: float) -> void:
	return # So I can create a new gun meccanic without starting from scratch
	
	if not parent.is_multiplayer_authority(): return
	look_at(get_global_mouse_position())
	if Input.is_action_just_pressed("shoot"):
		var instance = bullet.instantiate()
		var direction = (get_global_mouse_position() - global_position).normalized()
		var spawn_pos = global_position + direction * spawn_distance
		
		get_tree().current_scene.add_child(instance)
		instance.global_position = spawn_pos
		instance.rotation = direction.angle()
