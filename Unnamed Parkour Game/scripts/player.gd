extends CharacterBody2D

@export var SPEED := 300
@export var JUMP_VELOCITY := -400
@export var adder := 150
var can_walljump = false

# Coyote time variables
var coyote_timer = 0.0
var coyote_duration = 0.2  # 0.1 seconds after leaving ground

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())

func _physics_process(delta: float) -> void:
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if !is_multiplayer_authority(): return

	# Handle coyote time
	if is_on_floor():
		coyote_timer = coyote_duration  # Reset timer when on ground
	else:
		coyote_timer -= delta  # Decrease timer when in air

	# Handle jump with coyote time
	if Input.is_action_just_pressed("jump") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0  # Reset timer after jumping

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("jump") and can_walljump:
		velocity.y = JUMP_VELOCITY
		can_walljump = false
	
	if Input.is_action_just_pressed("run"):
		SPEED += adder
		JUMP_VELOCITY -= adder
		coyote_duration += 1
	if Input.is_action_just_released("run"):
		SPEED -= adder
		JUMP_VELOCITY += adder
		coyote_duration -= 1

func _on_area_2d_body_entered(body: TileMap) -> void:
	can_walljump = true


func die():
	queue_free()
