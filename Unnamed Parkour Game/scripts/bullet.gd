extends CharacterBody2D

var is_alive := false
@export var speed: int = 300

func _enter_tree() -> void:
	is_alive = true

func _process(delta: float) -> void:
	if !is_alive: return
	position += transform.x * speed * delta

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		body.die()
	queue_free()
