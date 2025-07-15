class_name Enemy extends ScriptedEntity

@export var NameLabel: Label

var PlayerNode: Player
var touching_player = false

var title := "Sewage Worker Perhaps"

var physical_damage := 10.0

signal enemy_dead(_title: String)

func init_enemy(data: EnemyResource, _attack_cycle : Callable, _position: Vector2, _player: Player) -> void:
	title = data.title
	PlayerNode = _player
	add_to_group("Enemy")
	init_scripted_entity(data.health, data.move_force, _attack_cycle, _position)

func damage_player(dmg: float) -> void:
	PlayerNode.take_damage(dmg)

func die():
	enemy_dead.emit(title)
	super.die()

func _process(delta: float) -> void:
	var is_player_on_left_side = (global_position.direction_to(PlayerNode.global_position).x < 0)
	Sprite.flip_h = is_player_on_left_side
	super._process(delta)
