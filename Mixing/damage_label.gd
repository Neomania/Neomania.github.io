extends Label

@export var fire_color: Color
@export var earth_color: Color

func init(amount: float, type: String):
	set_text("%d" % round(amount))
	var color = Color(1.0, 0.0, 0.0, 3.0)
	
	match type:
		"LIGHTNING":
			color = Color(1.0, 1.0, 0.0, 3.0)
		"PHYSICAL":
			color = Color(1.0, 1.0, 1.0, 3.0)
		"WATER":
			color = Color(0.2, 0.2, 1.0, 3.0)
		"FIRE":
			color = fire_color + Color(0, 0, 0, 2.0)
		"EARTH":
			color = earth_color + Color(0, 0, 0, 2.0)
		"BONUS":
			color = Color(1.0, 0.0, 1.0, 3.0)
	
	set_self_modulate(color)
	
	
func _process(delta):
	set_self_modulate(self_modulate - Color(0, 0, 0, delta))
	
	if (self_modulate.a <= 0):
		queue_free()
