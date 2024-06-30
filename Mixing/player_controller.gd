extends CharacterBody2D

@export var playerSpeed: float = 1000.0
@export var maxHealth = 100.0

var enemy_list: Array[Enemy] = []
var health = 1

var weapon_stats: Array[DamageBlock] = []
var attack_timer = 1.0

func _ready():
	health = maxHealth

func _process(delta):
	var moveVector := Vector2(0, 0)
	if (Input.is_action_pressed("game_move_up")):
		moveVector += Vector2(0.0, -1.0)
	if (Input.is_action_pressed("game_move_down")):
		moveVector += Vector2(0.0, 1.0)
	if (Input.is_action_pressed("game_move_left")):
		moveVector += Vector2(-1.0, 0.0)
	if (Input.is_action_pressed("game_move_right")):
		moveVector += Vector2(1.0, 0.0)
	
	if (moveVector.x != 0 or moveVector.y != 0):
		$WeaponCollider.set_rotation(moveVector.angle() + PI / 2)
	#if (Input.is_action_just_pressed("game_cauldron_cast")):
		#var damageAmount = get_tree().get_first_node_in_group("OrbStorage").get_total_damage()
		#get_node("../Enemy").damage(damageAmount)
		#get_tree().get_first_node_in_group("OrbStorage").clear_orbs()
		
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	if (enemies.size() > 0):
		enemies.sort_custom(func (a, b): return (a.global_position - global_position).length_squared() < (b.global_position - global_position).length_squared())
		$WeaponCollider.set_rotation((enemies[0].global_position - global_position).normalized().angle() + PI / 2)
	
	attack_timer -= delta
	if (attack_timer <= 0):
		var colliding_enemies = $WeaponCollider.get_overlapping_bodies()
		
		for enemy in colliding_enemies:
			if (enemy is Enemy):
				for block in weapon_stats:
					enemy.damage(block.amount, block.type)
					
		if (colliding_enemies.size() > 0):
			get_tree().call_group("OrbReceiver", "damage_orbs", 1)
		$WeaponCollider/CollisionPolygon2D/Polygon2D.set_self_modulate(Color(1.0, 1.0, 1.0, 1.0))
		
		attack_timer = 1.0
		
	#if (Input.is_action_just_pressed("game_weapon_attack")):
		#print(weapon_stats)
		#for enemy in $WeaponCollider.get_overlapping_bodies():
			#if (enemy is Enemy):
				#for block in weapon_stats:
					#enemy.damage(block.amount, block.type)
		#
		#$WeaponCollider/CollisionPolygon2D/Polygon2D.set_self_modulate(Color(1.0, 1.0, 1.0, 1.0))
	#
	$WeaponCollider/CollisionPolygon2D/Polygon2D.set_self_modulate($WeaponCollider/CollisionPolygon2D/Polygon2D.self_modulate - Color(0, 0, 0, delta))
	
	for enemy in enemy_list:
		health -= enemy.contact_damage * delta
	
	$HealthBar.set_scale(Vector2((float(health) / maxHealth) * 16, 1))
	
	set_velocity(playerSpeed * moveVector.normalized())
	
	move_and_slide()

func update_weapon(new_blocks):
	weapon_stats = new_blocks

func _on_enemy_collider_body_entered(body):
	enemy_list.push_back(body)
	pass # Replace with function body.


func _on_enemy_collider_body_exited(body):
	enemy_list.remove_at(enemy_list.find(body))
	pass # Replace with function body.
