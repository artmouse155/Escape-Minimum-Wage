extends Node2D

@export var ResumeScene : PackedScene

const SPAWN_RATE := 0.1 # Enemies to spawn per second
const RESUME_SPEED := 1200.0
const RESUME_DAMAGE := 100

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
	resume.init(direction, RESUME_SPEED, RESUME_DAMAGE)
	add_child(resume)

func _process(delta: float) -> void:
	time_counter += delta
	if time_counter > SPAWN_RATE:
		time_counter = time_counter - SPAWN_RATE
		spawn_resumes(1)
