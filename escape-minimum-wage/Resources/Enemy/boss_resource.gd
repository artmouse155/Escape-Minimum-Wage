class_name BossResource extends EnemyResource

enum BossType {MEANIE}

func _init(_type: BossType, _health: float, _title: String) -> void:
	super._init(0, Type.BOSS, 0.0, _health, _title)
