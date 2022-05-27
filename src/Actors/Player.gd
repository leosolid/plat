extends Actor

export var stomp_impulse = 1500.0


func _physics_process(delta: float) -> void:
	var is_jump_interrupted := Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction := get_direction()
	_velocity = calc_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)


func get_direction() -> Vector2:
	var y_strength := -1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), y_strength
	)


func calc_move_velocity(linear_velocity: Vector2, direction: Vector2, speed: Vector2, is_jump_interrupted: bool) -> Vector2:
	var out = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out

func calc_stomp_velocity(linear_velocity: Vector2, impulse: float) -> Vector2:
	var out := linear_velocity
	out.y = -impulse
	return out

func _on_EnemyDetector_body_entered(body:Node):
	queue_free()


func _on_StompDetector_area_entered(area:Area2D):
	_velocity = calc_stomp_velocity(_velocity, stomp_impulse)