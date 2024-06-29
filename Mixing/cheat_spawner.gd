extends Node2D

func spawn_orb(resource):
	var orb = resource.instantiate()
	orb.set_global_position(get_global_mouse_position())
	$"%Orbs".add_child(orb)
	orb.set_collision_layer(1)
	orb.set_freeze_enabled(false)

func _process(_dt):
	if (Input.is_action_pressed("debug_1")):
		spawn_orb(load("res://orbs/orb_iron.tscn"))
	if (Input.is_action_pressed("debug_2")):
		spawn_orb(load("res://orbs/orb_carbon.tscn"))
	if (Input.is_action_pressed("debug_3")):
		spawn_orb(load("res://orbs/orb_copper.tscn"))
	if (Input.is_action_pressed("debug_4")):
		spawn_orb(load("res://orbs/orb_tin.tscn"))
	if (Input.is_action_pressed("debug_5")):
		spawn_orb(load("res://orbs/orb_lightning.tscn"))
	if (Input.is_action_pressed("debug_6")):
		spawn_orb(load("res://orbs/orb_fire.tscn"))
