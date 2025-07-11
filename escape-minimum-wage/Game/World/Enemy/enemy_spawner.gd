class_name EnemySpawner extends Node2D

@export var SpawnPath: Path2D
@export var Follow: PathFollow2D

@export var EnemyScene: PackedScene
@export var BossScene: PackedScene
@export var PlayerNode: Player

var max_enemies := 10
var spawn_rate := .1

var level := 1

var level_data = PlayerResource.levels

var time_counter := 0.0

signal enemy_dead(_raise_amt: float, _title: String)
signal boss_dead()

func spawn_enemies(num: int) -> void:
	assert(SpawnPath and Follow, "No SpawnPath and/or Follow")
	for i in range(num):
		if (get_enemy_count() >= max_enemies):
			break
		Follow.progress_ratio = randf()
		spawn_enemy(Follow.global_position)

func spawn_enemy(pos: Vector2) -> void:
	assert(EnemyScene, "No EnemyScene")
	var min_pay = level_data[level - 1][PlayerResource.LevelDataTypes.MIN_PAY]
	var max_pay = level_data[level - 1][PlayerResource.LevelDataTypes.MAX_PAY]
	var enemydata = EnemyResource.new(level, EnemyResource.Type.COMMON, randf_range(min_pay, max_pay), 300, "Sewage Worker",)
	var enemy : Enemy = EnemyScene.instantiate()
	enemy.init(enemydata, pos, PlayerNode)
	enemy.dead.connect(on_dead)
	add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_counter += delta
	if time_counter > spawn_rate:
		time_counter = time_counter - spawn_rate
		spawn_enemies(1)
	

func get_enemy_count() -> int:
	return get_tree().get_nodes_in_group("Enemy").size()

func kill_all_enemies():
	var enemies : Array[Node] = get_tree().get_nodes_in_group("Enemy")
	for enemy in enemies:
		if enemy is Enemy:
			enemy.die()

func on_playerdata_updated(playerdata : PlayerResource):
	level = playerdata.level

func on_dead(_raise_amt: float, _title: String):
	enemy_dead.emit(_raise_amt, _title)

func summon_boss():
	kill_all_enemies()
	
