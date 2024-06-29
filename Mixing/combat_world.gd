extends Node2D

var spawn_timer = 0
var enemy_scene = preload("res://enemy.tscn")
var wave_counter = 1

func _process(delta):
	spawn_timer -= delta
	if (spawn_timer < 0):
		var enemy_count = wave_counter * 5
		for i in range(0, enemy_count):
			var enemy = enemy_scene.instantiate()
			if (wave_counter % 2 == 1):
				enemy.ai_type = Enemy.AIType.DIRECT
			else:
				enemy.ai_type = Enemy.AIType.INDIRECT
			
			enemy.set_global_position(1000 * Vector2.from_angle(2 * PI * (float(i) / enemy_count)))
			$SubViewportContainer2/SubViewport/Overworld.add_child(enemy)
		
		spawn_timer = 50
		wave_counter += 1
