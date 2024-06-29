extends Node2D
class_name OrbHolder

@export var target: Vector2
@export var speed: float = 300

#some multiple of 64
var magicSelectionNumber = 1216


func _ready():
	set_position(target);
	
func _process(_dt):
	# less than fractional lerp threshold
	if (target.x == magicSelectionNumber):
		set_position(position + (target + Vector2(0.0, 32.0) - position) * 0.05)
	else:
		set_position(position + (target - position) * 0.05)
	
	if (Input.is_action_just_pressed("game_orb_drop") and target.x == magicSelectionNumber):
		# drop orb
		var orb: RigidBody2D = get_child(0)
		orb.set_freeze_enabled(false)
		orb.set_collision_layer(1)
		orb.reparent(get_node("../.."))
		orb.apply_impulse(Vector2(randf_range(-1.0, 1.0), 0.0))
		
		get_node("../../../Orb Belt").cycle_belt()
		
		queue_free()
		
	if (target.x > 1700):
		queue_free()

func set_target_position(newTarget: Vector2):
	target = newTarget
