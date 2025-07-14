class_name ScriptedEntity extends Entity

var attack_cycle : Callable

var attack_cycle_tween : Tween

func init_scripted_entity(_init_health: float, _move_force: float, _attack_cycle : Callable, _position : Vector2) -> void:
	global_position = _position
	attack_cycle = _attack_cycle
	attack()
	init(_init_health, _move_force)

func attack():
	if attack_cycle:
		if attack_cycle_tween:
			attack_cycle_tween.kill()
		attack_cycle_tween = create_tween()
		attack_cycle_tween.finished.connect(attack)
		attack_cycle.call()
