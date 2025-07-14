class_name World extends Node2D

@export var PlayerNode: Player
@export var EnemySpawnerNode : EnemySpawner

@export var Camera: Camera2D

signal restart

func _ready() -> void:
	PlayerNode.dead.connect(on_player_dead)

func reset_player_and_enemies() -> void:
	PlayerNode.reset_position_and_health_and_projectiles()
	EnemySpawnerNode.kill_all_enemies()
	# DESTROY ALL PROJECTILES

func on_player_dead():
	restart.emit()
