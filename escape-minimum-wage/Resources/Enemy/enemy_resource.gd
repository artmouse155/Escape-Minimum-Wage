class_name EnemyResource extends Resource

enum Type {COMMON, UNCOMMON, LEGENDARY, BOSS}

@export var level: int = 1
@export var type: Type = Type.COMMON
@export var raise_amt: float = 0.00
@export var health: float = 100.0
@export var title: String = "Game Developer"

func _init(_level: int, _type: Type, _raise_amt: float, _health: float, _title: String) -> void:
	level = _level
	type = _type
	raise_amt = _raise_amt
	health = _health
	title = _title

func get_name_label():
	return "Lv %d %s" % [level, title]
