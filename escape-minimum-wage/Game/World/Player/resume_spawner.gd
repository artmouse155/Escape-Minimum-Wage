class_name ResumeSpawner extends Node2D

@export var ResumeScene : PackedScene

# We get this from the incoming playerData
var resume_spawn_rate := 0.0 # Resumes to throw per second
var resume_speed := 0.0
var resume_damage := 0.0

var time_counter := 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_resumes(num : int):
	for i in range(num):
		spawn_resume(global_position.direction_to(get_global_mouse_position()))

func spawn_resume(direction: Vector2):
	assert(ResumeScene, "No ResumeScene")
	var resume: Resume = ResumeScene.instantiate()
	resume.init(direction, resume_speed, resume_damage)
	add_child(resume)

func _process(delta: float) -> void:
	time_counter += delta
	if time_counter > resume_spawn_rate:
		time_counter = time_counter - resume_spawn_rate
		spawn_resumes(1)

func on_playerdata_updated(playerdata : PlayerResource):
	resume_spawn_rate = playerdata.resume_spawn_rate
	resume_speed = playerdata.resume_speed
	var resume_tier := playerdata.get_upgrade(Shop.UpgradeTypes.RESUME_TIER)
	if resume_tier.values.has("impact"):
		resume_damage = float(resume_tier.values["impact"])
	else:
		resume_damage = 0
