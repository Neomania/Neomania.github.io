extends CharacterBody2D
class_name Enemy

enum AIType {
	SANDBAG = 0,
	DIRECT,
	INDIRECT,
}

@export var health = 100.0
@export var ai_type: AIType = AIType.SANDBAG
@export var speed = 100.0

@export var contact_damage = 20

var hitstun = 0

var damage_scene = preload("res://damage_label.tscn")

var ai_scratch := {}

func damage(amount: float, type: String = "null"):
	print("%f, %s" % [amount, type])
	health -= amount
	
	var dmg = damage_scene.instantiate()
	dmg.init(amount, type)
	dmg.set_global_position(global_position + 50 * Vector2.from_angle(randf_range(-PI, PI)))
	
	get_parent().add_child(dmg)
	
	hitstun = 0.5
	
	if (health <= 0):
		queue_free()

func go_towards_player():
	velocity = speed * (ai_scratch["player"].global_position - global_position).normalized()

func _process(dt):
	if (ai_scratch.get("player", null) == null):
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			ai_scratch["player"] = players[0]
	
	hitstun -= dt
	
	if (hitstun > 0):
		return
	
	match ai_type:
		AIType.SANDBAG:
			pass
		AIType.DIRECT:
			go_towards_player()
		AIType.INDIRECT:
			if (ai_scratch.get("wander_timer", -1.0) < 0):
				if (randf() < 0.001):
					ai_scratch["wander_timer"] = randf_range(0.5, 1.5)
					ai_scratch["wander_direction"] = Vector2.from_angle(randf_range(0, PI * 2))
					velocity = ai_scratch["wander_direction"] * speed
				else:
					go_towards_player()
			else:
				ai_scratch["wander_timer"] -= dt
	
	move_and_slide()
