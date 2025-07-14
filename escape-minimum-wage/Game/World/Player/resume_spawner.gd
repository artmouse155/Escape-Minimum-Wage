class_name ResumeSpawner extends Node2D

@export var ResumeScene : PackedScene

const ENEMY_GROUP = "Enemy"

const SPREAD_RAD := 0.1 # Spread in radians

# We get this from the incoming playerData
var resume_spawn_rate := 0.0 # Resumes to throw per second
var resume_speed := 0.0

var resume_damage := 0.0
var thrown_resumes := 1

var time_counter := 0.0

func spawn_resumes(num : int):
	var direction = global_position.direction_to(get_global_mouse_position())
	var total_gap = (num - 1) * SPREAD_RAD
	var half_gap = total_gap / 2
	direction = direction.rotated(-half_gap)
	for i in range(num):
		spawn_resume(direction)
		direction = direction.rotated(SPREAD_RAD)

func spawn_resume(direction: Vector2):
	assert(ResumeScene, "No ResumeScene")
	var resume: Projectile = ResumeScene.instantiate()
	resume.init(direction, resume_speed, resume_damage, ENEMY_GROUP)
	add_child(resume)

func _process(delta: float) -> void:
	time_counter += delta
	if time_counter > resume_spawn_rate:
		time_counter = time_counter - resume_spawn_rate
		spawn_resumes(thrown_resumes)

func on_playerdata_updated(playerdata : PlayerResource):
	resume_spawn_rate = playerdata.resume_spawn_rate
	resume_speed = playerdata.resume_speed
	var resume_tier := playerdata.get_upgrade(Shop.UpgradeTypes.RESUME_TIER)
	if resume_tier.values.has("impact"):
		resume_damage = float(resume_tier.values["impact"])
	else:
		resume_damage = 0
	
	var networking := playerdata.get_upgrade(Shop.UpgradeTypes.NETWORKING)
	if networking.values.has("thrown_resumes"):
		thrown_resumes = int(networking.values["thrown_resumes"])
	else:
		thrown_resumes = 0

func destroy_projectiles():
	for child in get_children():
		child.queue_free()
