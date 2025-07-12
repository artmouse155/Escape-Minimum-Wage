class_name Player extends RigidBody2D

@export var ResumeSpawnerNode: ResumeSpawner

var move_force = 0
var dash_force = 0
var dash_cooldown = 0
var dash_timer = 0

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var move_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	if Input.is_action_just_pressed("dash") and (move_dir != Vector2.ZERO) and (dash_timer == 0):
		print("Dash")
		dash_timer = dash_cooldown
		state.apply_central_force(dash_force * move_dir)
	else:
		state.apply_central_force(move_force * move_dir)

func on_playerdata_updated(playerdata : PlayerResource):
	move_force = playerdata.speed
	dash_force = playerdata.dash_force
	dash_cooldown = playerdata.dash_cooldown
	ResumeSpawnerNode.on_playerdata_updated(playerdata)

func _process(delta: float) -> void:
	dash_timer = max(0, dash_timer-delta)
