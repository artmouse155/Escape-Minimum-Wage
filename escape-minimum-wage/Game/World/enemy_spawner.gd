extends Node2D

@export var SpawnPath: Path2D
@export var Follow: PathFollow2D

@export var EnemyScene: PackedScene
@export var player: Player

const MAX_ENEMIES = 100

const SPAWN_RATE = 0.1 # Enemies to spawn per second

var time_counter := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_enemies(5)

func spawn_enemies(num: int) -> void:
	assert(SpawnPath and Follow, "No SpawnPath and/or Follow")
	for i in range(num):
		if (get_enemy_count() > MAX_ENEMIES):
			push_error("Max enemy count reached")
			break
		Follow.progress_ratio = randf()
		spawn_enemy(Follow.global_position)

func spawn_enemy(pos: Vector2) -> void:
	assert(EnemyScene, "No EnemyScene")
	var enemy : Enemy = EnemyScene.instantiate()
	enemy.init(pos, player)
	add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_counter += delta
	if time_counter > SPAWN_RATE:
		time_counter = time_counter - SPAWN_RATE
		spawn_enemies(1)
	

func get_enemy_count() -> int:
	return get_tree().get_nodes_in_group("Enemy").size()
