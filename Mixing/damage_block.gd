extends Object
class_name DamageBlock

enum DamageType {
	PHYSICAL = 1,
	FIRE,
	WATER,
	LIGHTNING,
	EARTH,
}

var amount: float
var type: String

func _init(amt: float, typ: String):
	amount = amt
	type = typ
