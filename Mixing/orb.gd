extends DraggableBody
class_name Orb

@export var typecode: String = "NULL"

var health = 5

func _ready():
	health = randi_range(8, 20)

func deferred_change_orb(orb):
	get_parent().add_child(orb)
	self.queue_free()

func _on_body_entered(body):
	if (freeze == false and body is Orb and body.freeze == false and self.typecode == "WATER" and body.typecode == "FIRE"):
		var steamOrb = load("res://orbs/orb_steam.tscn").instantiate()
		steamOrb.set_position(position)
		steamOrb.set_linear_velocity(linear_velocity)
		steamOrb.set_angular_velocity(angular_velocity)
		steamOrb.set_rotation(rotation)
		steamOrb.set_collision_layer(1)
		steamOrb.set_freeze_enabled(false)
		
		call_deferred("deferred_change_orb", steamOrb)
		self.queue_free()
