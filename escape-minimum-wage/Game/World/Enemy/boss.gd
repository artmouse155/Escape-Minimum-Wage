class_name Boss extends Enemy

var attack_cycles : Dictionary[BossResource.BossType, Callable] = {
	BossResource.BossType.BASIC : basic_attack_cycle,
	BossResource.BossType.BURGER : burger_attack_cycle
}

# Called when the node enters the scene tree for the first time.
func init_boss(data : BossResource, _position: Vector2, _player: Player) -> void:
	add_to_group("Boss")
	init_enemy(data, attack_cycles[data.boss_type], _position, _player)

func basic_attack_cycle():
	pass
	
func burger_attack_cycle():
	pass
