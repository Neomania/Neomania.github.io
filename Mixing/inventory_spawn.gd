extends Area2D

var queue: Array[Node2D] = []
@export var spawn_interval = 0.1
var spawn_counter = 0

func try_receive(orb):
	if (queue.size() >= 100):
		return false
	else:
		queue.push_back(orb)

func _physics_process(delta):
	if (queue.size() > 0 and delta < 0):
		get_node("")
	
	spawn_counter -= delta
