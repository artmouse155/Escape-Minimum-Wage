class_name EnemyResource extends Resource

enum Type {REGULAR, BOSS}

@export var move_force := 2000.0

@export var type: Type = Type.REGULAR

@export var health: float = 100.0
@export var title: String = "Game Developer"

var attack_cycle

func _init(_type: Type, _health: float, _title: String) -> void:
	type = _type
	health = _health
	title = _title
