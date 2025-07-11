class_name Player extends CharacterBody2D

const ACCEL := 100
const MAX_VEL := 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	var move_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	velocity += move_dir * ACCEL
	move_and_slide()
