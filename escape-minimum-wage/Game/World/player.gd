class_name Player extends RigidBody2D

const ACCEL := 60000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	var move_dir = Vector2(Input.get_axis("left", "right"), Input.get_axis("up", "down"))
	state.apply_central_force(ACCEL * move_dir)
