extends Node2D

var holderScene = preload("res://orb_holder.tscn")
@export var orbScenes: Array[PackedScene]
var elements := [
	[1.0, preload("res://orbs/orb_fire.tscn")],
	[1.0, preload("res://orbs/orb_water.tscn")],
	[1.0, preload("res://orbs/orb_lightning.tscn")]
]

var orbs := {
	"FIRE": preload("res://orbs/orb_fire.tscn"),
	"WATER": preload("res://orbs/orb_water.tscn"),
	"LIGHTNING": preload("res://orbs/orb_lightning.tscn"),
}

var weightSum: float = 0.0

var cycleQueued: bool = false

func add_orb(orbScene: PackedScene):
	var holder: Node2D = holderScene.instantiate()
	var orb = orbScene.instantiate()
	orb.set_freeze_enabled(true)
	holder.add_child(orb)
	
	$Holders.add_child(holder)
	
	# move all holders to the right
	var holders = $Holders.get_children()
	for h in holders:
		h.set_target_position(h.target + Vector2(64, 0))

# Polls world for an orb to give the player
func request_orb():
	return pick_orb()
	var sources = get_tree().get_nodes_in_group("OrbSources")
	
	if (sources.size() == 0):
		push_error("Attempted to get orb with no OrbSource present! Using fallback.")
		return pick_orb()
		
	if (sources.size() > 1):
		push_warning("Found more than one OrbSource when calling request_orb!")
	
	if (sources[0].has_method("pick_orb")):
		return orbs[sources[0].pick_orb()]
	else:
		push_error("OrbSource did not have pick_orb method defined.")
		return load("res://orb.tscn")
	

func pick_orb():
	var pick = randf_range(0.0, weightSum)
	for x in elements:
		if (pick < x[0]):
			return x[1]
		else:
			pick -= x[0]
	
	return load("res://orb.tscn")

func _ready():
	elements.clear()
	orbs = {}
	for scene in orbScenes:
		var state = scene.get_state()
		var typecode = null
		for i in range(0, state.get_node_property_count(0)):
			if (state.get_node_property_name(0, i) == "typecode"):
				typecode = state.get_node_property_value(0, i)
				break
		
		if (typecode == null):
			push_error("Could not find typecode for:")
			push_error(scene)
		else:
			elements.push_back([1.0, scene])
			orbs[typecode] = scene
			
	weightSum = 0.0
	for o in elements:
		weightSum += o[0]
	
	for x in range(24):
		add_orb(pick_orb())

func cycle_belt():
	cycleQueued = true

func _process(_dt):
	if (Input.is_action_just_pressed("game_belt_cycle")):
		add_orb(request_orb())
		
	if (cycleQueued):
		cycleQueued = false
		add_orb(request_orb())
