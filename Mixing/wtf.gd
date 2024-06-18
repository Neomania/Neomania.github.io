extends Sprite2D

func _process(dt):
	print("wtf")
	print(position)
	print(global_position)
	if (Input.is_action_just_pressed("ui_right")):
		set_position(Vector2(1600, 900))
