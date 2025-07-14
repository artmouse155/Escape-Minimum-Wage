class_name EnemySpawner extends Node2D

@export var SpawnPath: Path2D
@export var Follow: PathFollow2D

@export var RegularEnemyScene: PackedScene
@export var BossScene: PackedScene
@export var PlayerNode: Player

var max_enemies := 5
var spawn_rate := 1

var level := 1

var level_data = PlayerResource.levels

var time_counter := 0.0

signal regular_enemy_dead(_raise_amt: float, _title: String)
signal boss_dead

var disabled = false

func spawn__regular_enemies(num: int) -> void:
	assert(SpawnPath and Follow, "No SpawnPath and/or Follow")
	for i in range(num):
		if (get_enemy_count() >= max_enemies):
			break
		Follow.progress_ratio = randf()
		spawn_regular_enemy(Follow.global_position)

func spawn_regular_enemy(pos: Vector2) -> void:
	var min_pay = level_data[level - 1][PlayerResource.LevelDataTypes.MIN_PAY]
	var max_pay = level_data[level - 1][PlayerResource.LevelDataTypes.MAX_PAY]
	var enemydata = RegularEnemyResource.new(level, randf_range(min_pay, max_pay), RegularEnemyResource.RegType.COMMON, 300, "Sewage Worker",)
	var regular_enemy : RegularEnemy = RegularEnemyScene.instantiate()
	regular_enemy.init_reg(enemydata, pos, PlayerNode)
	regular_enemy.regular_enemy_dead.connect(on_regular_enemy_dead)
	add_child(regular_enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_counter += delta
	if (time_counter > spawn_rate) and not disabled:
		time_counter = time_counter - spawn_rate
		spawn__regular_enemies(1)
	

func get_enemy_count() -> int:
	return get_tree().get_nodes_in_group("Enemy").size()

## Doesn't drop a raise reward
func kill_all_enemies(kill_boss : bool = false):
	var enemies : Array[Node] = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if enemy is RegularEnemy and (kill_boss or not enemy.is_in_group("Boss")):
			enemy.die(false)

func on_playerdata_updated(playerdata : PlayerResource):
	level = playerdata.level
	disabled = playerdata.is_fighting_boss

func on_regular_enemy_dead(_raise_amt: float, _title: String):
	regular_enemy_dead.emit(_raise_amt, _title)

func on_boss_dead(_title: String):
	print("Boss died.")
	boss_dead.emit()

func summon_boss():
	print("Summoning Boss")
	kill_all_enemies()
	var bossdata = BossResource.new(BossResource.BossType.BASIC)
	var boss : Boss = BossScene.instantiate()
	Follow.progress_ratio = randf()
	boss.init_boss(bossdata, Follow.global_position, PlayerNode)
	boss.enemy_dead.connect(on_boss_dead)
	add_child(boss)
