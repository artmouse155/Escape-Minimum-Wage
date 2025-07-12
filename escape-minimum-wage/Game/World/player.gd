class_name Player extends RigidBody2D

@export var ResumeSpawnerNode: ResumeSpawner

var move_force = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var move_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	state.apply_central_force(move_force * move_dir)

func on_playerdata_updated(playerdata : PlayerResource):
	move_force = playerdata.speed
	ResumeSpawnerNode.on_playerdata_updated(playerdata)
