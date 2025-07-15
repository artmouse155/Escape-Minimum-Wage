class_name World extends Node2D

@export var PlayerNode: Player
@export var EnemySpawnerNode : EnemySpawner

@export var Camera: Camera2D

signal restart

var camera_tween # tweening for a ground pound

const CAMERA_TWEEN_TIME := 0.6

func _ready() -> void:
	PlayerNode.dead.connect(on_player_dead)
	EnemySpawnerNode.boss_ground_pound.connect(ground_pound)

func reset_player_and_enemies() -> void:
	PlayerNode.reset_position_and_health_and_projectiles()
	EnemySpawnerNode.kill_all_enemies(true)
	# DESTROY ALL PROJECTILES

func on_player_dead():
	restart.emit()


func ground_pound():
	if camera_tween:
		camera_tween.kill()
	camera_tween = create_tween()
	Camera.offset.y = -200
	camera_tween.tween_property(Camera,"offset:y",0, CAMERA_TWEEN_TIME).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
