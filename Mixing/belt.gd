extends Node2D

var holderScene = preload("res://orb_holder.tscn")
var elements := [
	[1.0, preload("res://orbs/orb_fire.tscn")],
	[1.0, preload("res://orbs/orb_water.tscn")],
	[1.0, preload("res://orbs/orb_lightning.tscn")]
]

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

func pick_orb():
	var pick = randf_range(0.0, weightSum)
	for x in elements:
		if (pick < x[0]):
			return x[1]
		else:
			pick -= x[0]
	
	return load("res://orb.tscn")

func _ready():
	weightSum = 0.0
	for o in elements:
		weightSum += o[0]
	
	for x in range(24):
		add_orb(pick_orb())

func cycle_belt():
	cycleQueued = true

func _process(delta):
	if (Input.is_action_just_pressed("game_belt_cycle")):
		add_orb(pick_orb())
		
	if (cycleQueued):
		cycleQueued = false
		add_orb(pick_orb())
