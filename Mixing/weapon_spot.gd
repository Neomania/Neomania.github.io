extends Node2D

func _on_orb_sensor_body_entered(body):
	get_tree().call_group("OrbReceiver", "orb_added", body)
	pass # Replace with function body.


func _on_orb_sensor_body_exited(body):
	get_tree().call_group("OrbReceiver", "orb_removed", body)
	pass # Replace with function body.
