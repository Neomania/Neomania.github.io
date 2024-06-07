extends Sprite2D

func _process(dt):
	if Input.is_action_pressed("ui_left"):
		set_global_position(global_position - Vector2(500 * dt, 0.0))
	if Input.is_action_pressed("ui_right"):
		set_global_position(global_position + Vector2(500 * dt, 0.0))
	if Input.is_action_pressed("ui_up"):
		set_global_position(global_position - Vector2(0.0, 500 * dt))
	if Input.is_action_pressed("ui_down"):
		set_global_position(global_position + Vector2(0.0, 500 * dt))
