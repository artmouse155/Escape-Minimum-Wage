class_name World extends Node2D

@export var PlayerNode: Player
@export var EnemySpawnerNode : EnemySpawner

@export var Camera: Camera2D


func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("reset"):
		PlayerNode.position = Vector2.ZERO
		PlayerNode.linear_velocity = Vector2.ZERO
		EnemySpawnerNode.kill_all_enemies()
