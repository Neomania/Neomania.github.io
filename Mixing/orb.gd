extends RigidBody2D
class_name Orb

@export var typecode: String = "NULL"

func _on_body_entered(body):
	if (freeze == false and body is Orb and body.freeze == false and self.typecode == "WATER" and body.typecode == "FIRE"):
		var steamOrb = load("res://orbs/orb_steam.tscn").instantiate()
		steamOrb.set_position(position)
		steamOrb.set_linear_velocity(linear_velocity)
		steamOrb.set_angular_velocity(angular_velocity)
		steamOrb.set_rotation(rotation)
		steamOrb.set_collision_layer(1)
		steamOrb.set_freeze_enabled(false)
		
		get_parent().add_child(steamOrb)
		body.queue_free()
		self.queue_free()
