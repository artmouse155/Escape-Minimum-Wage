class_name RegularEnemyResource extends EnemyResource

enum RegType {COMMON, UNCOMMON, LEGENDARY}

@export var raise_amt: float = 0.00
@export var level: int = 1

func get_name_label():
	return "Lv %d %s" % [level, title]

func _init(_level: int, _raise_amt: float, _type: RegType, _health: float, _title: String):
	level = _level
	raise_amt = _raise_amt
	super._init(Type.REGULAR, _health, _title)
