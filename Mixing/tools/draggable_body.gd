extends RigidBody2D
class_name DraggableBody

var active = false
var dragging = false

func _on_mouse_entered():
	active = true
	pass # Replace with function body.

func _process(dt):
	if (active and Input.is_action_just_pressed("game_item_drag")):
		dragging = true
		if (get_parent().has_method("on_drag")):
			get_parent().call("on_drag")
		
	if (dragging):
		if (Input.is_action_pressed("game_item_drag")):
			var mousePos = get_global_mouse_position()
			var P = mousePos - global_position
			var mouseDir = P.normalized()
			var D = linear_velocity
			var strength = 10 * (P * 0.4 - D * 0.05)
			
			# clamping factor
			var maxImpulse = 160
			if (strength.length() > maxImpulse):
				strength = strength.normalized() * maxImpulse
				
			apply_central_impulse(strength)
		else:
			dragging = false

func _on_mouse_exited():
	active = false
	pass # Replace with function body.
