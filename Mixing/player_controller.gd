extends CharacterBody2D

@export var playerSpeed: float = 1000.0

func _process(delta):
	var moveVector := Vector2(0, 0)
	if (Input.is_action_pressed("game_move_up")):
		moveVector += Vector2(0.0, -1.0)
	if (Input.is_action_pressed("game_move_down")):
		moveVector += Vector2(0.0, 1.0)
	if (Input.is_action_pressed("game_move_left")):
		moveVector += Vector2(-1.0, 0.0)
	if (Input.is_action_pressed("game_move_right")):
		moveVector += Vector2(1.0, 0.0)
		
	set_velocity(playerSpeed * moveVector.normalized())
	
	move_and_slide()
	
